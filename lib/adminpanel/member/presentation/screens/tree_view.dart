import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/cubit/visibilityCubit/visibility_cubit.dart';
import 'package:family_tree/adminpanel/member/cubit/visibilityCubit/visibility_state.dart';
import 'package:family_tree/adminpanel/member/model/visibility_model.dart';
import 'package:family_tree/adminpanel/member/presentation/widgets/two_container.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:graphview/GraphView.dart';

import 'package:family_tree/models/family_member.dart';
import 'package:family_tree/screens/filter_drop_down_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TreeViewScreen extends StatefulWidget {
  const TreeViewScreen({super.key});

  @override
  State<TreeViewScreen> createState() => _TreeViewScreenState();
}

class _TreeViewScreenState extends State<TreeViewScreen> {
  final TextEditingController searchController = TextEditingController();
  Set<String> selectedFilters = {};
  final GlobalKey _graphKey = GlobalKey();
  bool isDownloading = false;

  final BuchheimWalkerConfiguration _treeConfig = BuchheimWalkerConfiguration()
    ..siblingSeparation = 20
    ..levelSeparation = 50
    ..subtreeSeparation = 30
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().subscribeToMembers();
    // fetch from Firestore
    context.read<VisibilityCubit>().fetchVisibility();
  }

  Graph buildGraphFromMembers(
    List<FamilyMember> members,
    VisibilityModel visibility,
  ) {
    final graph = Graph();
    final Map<String, Node> nodeMap = {};
    final Set<String> addedMemberIds = {};

    // Root node
    final rootNode = Node.Id('Jai Hatkesh');
    rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
    graph.addNode(rootNode);

    for (var member in members) {
      // Skip if this member is already processed
      if (addedMemberIds.contains(member.id)) {
        debugPrint("⏭ Skipping ${member.name}, already added");
        continue;
      }

      final spouse = member.spouse;
      final spouseExists =
          spouse != null && members.any((m) => m.id == spouse.id);

      // Case 1: Married with valid spouse
      if (member.isMarried && spouseExists) {
        final coupleNode = Node.Id('${member.id}-${spouse.id}');
        coupleNode.key = ValueKey(
          MemberBox(member, spouse, visibility: visibility),
        );
        graph.addNode(coupleNode);

        nodeMap[member.id] = coupleNode;
        nodeMap[spouse.id] = coupleNode;

        addedMemberIds.add(member.id);
        addedMemberIds.add(spouse.id);

        debugPrint("💍 Couple node added for ${member.name} + ${spouse.name}");
      }
      // Case 2: Single unmarried member
      else if (!member.isMarried &&
          (member.spouseId == null || member.spouseId!.isEmpty)) {
        final node = Node.Id(member.id);
        node.key = ValueKey(MemberBox(member, null, visibility: visibility));
        graph.addNode(node);

        nodeMap[member.id] = node;
        addedMemberIds.add(member.id);

        debugPrint(
          "🟢 Single node added for ${member.name} "
          "(Unmarried, spouseId=null/empty)",
        );
      }
      // Case 3: Skip everything else
      else {
        debugPrint(
          "⚪ Skipping ${member.name}, "
          "isMarried=${member.isMarried}, spouseId=${member.spouseId}",
        );
      }
    }

    // Build edges
    for (var member in members) {
      if (!nodeMap.containsKey(member.id)) continue;

      final node = nodeMap[member.id]!;
      if (member.isRoot ||
          member.parentId == null ||
          member.parentId!.isEmpty ||
          !nodeMap.containsKey(member.parentId)) {
        graph.addEdge(rootNode, node);
      } else {
        graph.addEdge(nodeMap[member.parentId!]!, node);
      }
    }

    return graph;
  }

  void _openFilterSheet(List<FamilyMember> members) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 1,
        child: FilterDropdownSheet(
          members: members,
          selected: selectedFilters,
          onApply: (filters) {
            setState(() => selectedFilters = filters);
            context.read<MemberCubit>().applyFilters(filters);
          },
          onClear: () {
            setState(() => selectedFilters.clear());
            context.read<MemberCubit>().clearFilters();
          },
        ),
      ),
    );
  }

  Widget _labelBox(String label) {
    return Container(
      width: 200,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _downloadTreeAsPdf() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.generatingPdf),
          ],
        ),
      ),
    );

    try {
      await Future.delayed(Duration(milliseconds: 100)); // Let dialog show

      final bytes = await _captureTreeAsImage();
      if (bytes == null) return;

      final pdf = pw.Document();
      final image = pw.MemoryImage(bytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (context) => pw.Center(child: pw.Image(image)),
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: "family_tree.pdf",
      );
    } finally {
      Navigator.of(context).pop(); // Close dialog
    }
  }

  Future<Uint8List?> _captureTreeAsImage() async {
    try {
      RenderRepaintBoundary boundary =
          _graphKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("❌ ${AppLocalizations.of(context)!.errorCapturingTree}$e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VisibilityCubit, VisibilityState>(
      builder: (context, visibilityState) {
        // if (visibilityState.loading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        final visibility = visibilityState.visibility;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.title,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.download, color: Colors.white),
              //   onPressed: _downloadTreeAsPdf,
              // ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  switch (value) {
                    case 'download':
                      _downloadTreeAsPdf();
                      break;
                    case 'filters':
                      // you’ll pass members from StreamBuilder
                      // _openFilterSheet(members);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(Icons.download, color: Colors.black54),
                        SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.downloadPdf),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: StreamBuilder<List<FamilyMember>>(
            stream: context.read<MemberCubit>().membersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: \${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noMembersFound),
                );
              }

              final members = snapshot.data!;
              final graph = buildGraphFromMembers(
                members,
                visibility ??
                    VisibilityModel(
                      showAliveStatus: true,
                      showContact: true,
                      showDOB: true,
                      showSpouse: true,
                      showEmail: true,
                      showBloodGroup: true,
                      showLocation: true,
                    ),
              );

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.all(12),
                      //   child: Card(
                      //     borderOnForeground: true,
                      //     shape: BoxBorder.all(color: AppColors.orangeDark),
                      //     child: Row(
                      //       children: [
                      // Expanded(
                      //   child: TextField(
                      //     controller: searchController,
                      //     decoration: InputDecoration(
                      //       hintText: AppLocalizations.of(
                      //         context,
                      //       )!.searchByName,
                      //       border: InputBorder.none,
                      //       enabledBorder: InputBorder.none,
                      //       focusedBorder: InputBorder.none,
                      //       contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 10,
                      //       ),
                      //     ),
                      //     onChanged: (value) {
                      //       context.read<MemberCubit>().search(
                      //         value.trim(),
                      //       );
                      //     },
                      //   ),
                      // ),
                      //         IconButton(
                      //           icon: const Icon(Icons.search),
                      //           onPressed: () {
                      //             context.read<MemberCubit>().search(
                      //               searchController.text.trim(),
                      //             );
                      //           },
                      //         ),
                      //         IconButton(
                      //           icon: const Icon(Icons.clear),
                      //           onPressed: () {
                      //             searchController.clear();
                      //             context.read<MemberCubit>().clearFilters();
                      //           },
                      //         ),
                      //         IconButton(
                      //           icon: const Icon(Icons.filter_list),
                      //           onPressed: () => _openFilterSheet(members),
                      //         ),99
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _openFilterSheet(members),
                            label: Text(AppLocalizations.of(context)!.filter),
                          ),
                        ),
                      ),

                      Expanded(
                        child: InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(200),
                          constrained: false,
                          minScale: 0.1,
                          maxScale: 5,
                          child: Center(
                            child: RepaintBoundary(
                              key: _graphKey,
                              child: GraphView(
                                graph: graph,
                                algorithm: BuchheimWalkerAlgorithm(
                                  _treeConfig,
                                  TreeEdgeRenderer(_treeConfig),
                                ),
                                builder: (Node node) =>
                                    node.key!.value as Widget,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isDownloading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

// Keep _MemberBox as is...

class MemberBox extends StatefulWidget {
  final FamilyMember member;
  final Spouse? spouse;
  final VisibilityModel visibility;

  const MemberBox(
    this.member,
    this.spouse, {
    required this.visibility,
    super.key,
  });

  @override
  State<MemberBox> createState() => _MemberBoxState();
}

class _MemberBoxState extends State<MemberBox> {
  @override
  Widget build(BuildContext context) {
    final m = widget.member;

    return CoupleCard(
      person: Person(
        name: m.name,
        phone: m.phone,
        email: m.email,
        isMarried: m.isMarried,
        gender: m.gender.toLowerCase() == 'male' ? Gender.male : Gender.female,
        spouse: m.spouse != null
            ? Person(
                name: m.spouse!.name,
                phone: m.spouse!.phone,
                email: m.spouse!.email,
                gender: m.spouse!.gender.toLowerCase() == 'male'
                    ? Gender.male
                    : Gender.female,
                location: m.spouse!.location,
                bloodGroup: m.spouse!.bloodGroup,
                isAlive: m.spouse!.isAlive,
                dob: m.spouse!.dob,
              )
            : null,
        location: m.location,
        bloodGroup: m.bloodGroup,
        isAlive: m.isAlive,
        dob: m.dob,
      ),
      visibility: widget.visibility,
    );
  }
}
