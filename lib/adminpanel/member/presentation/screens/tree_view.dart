import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/widgets/two_container.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';

import 'package:family_tree/models/family_member.dart';
import 'package:family_tree/screens/filter_drop_down_screen.dart';

class TreeViewScreen extends StatefulWidget {
  const TreeViewScreen({super.key});

  @override
  State<TreeViewScreen> createState() => _TreeViewScreenState();
}

class _TreeViewScreenState extends State<TreeViewScreen> {
  final TextEditingController searchController = TextEditingController();
  Set<String> selectedFilters = {};

  final BuchheimWalkerConfiguration _treeConfig = BuchheimWalkerConfiguration()
    ..siblingSeparation = 20
    ..levelSeparation = 50
    ..subtreeSeparation = 30
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().subscribeToMembers();
  }

  Graph buildGraphFromMembers(List<FamilyMember> members) {
    final graph = Graph();
    final Map<String, Node> nodeMap = {};

    // Root node
    final jaiHatkeshNode = Node.Id('Jai Hatkesh');
    graph.addNode(jaiHatkeshNode..key = ValueKey(_labelBox("Jai Hatkesh")));

    // Add all members
    for (var member in members) {
      final node = Node.Id(member.id);
      node.key = ValueKey(_MemberBox(member));
      graph.addNode(node);
      nodeMap[member.id] = node;
    }

    // Add edges
    for (var member in members) {
      final node = nodeMap[member.id]!;

      if (member.isRoot == 'true') {
        // Root members connect to Jai Hatkesh
        graph.addEdge(jaiHatkeshNode, node);
      } else if (member.parentId.isNotEmpty &&
          nodeMap.containsKey(member.parentId)) {
        graph.addEdge(nodeMap[member.parentId]!, node);
      } else {
        // Fallback to Jai Hatkesh if parent not found
        graph.addEdge(jaiHatkeshNode, node);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title,
          style: TextStyle(color: Colors.white),
        ),
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
          final graph = buildGraphFromMembers(members);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  borderOnForeground: true,
                  shape: BoxBorder.all(color: AppColors.orangeDark),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(
                              context,
                            )!.searchByName,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (value) {
                            context.read<MemberCubit>().search(value.trim());
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          context.read<MemberCubit>().search(
                            searchController.text.trim(),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          context.read<MemberCubit>().clearFilters();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => _openFilterSheet(members),
                      ),
                    ],
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
                    child: GraphView(
                      graph: graph,
                      algorithm: BuchheimWalkerAlgorithm(
                        _treeConfig,
                        TreeEdgeRenderer(_treeConfig),
                      ),
                      builder: (Node node) => node.key!.value as Widget,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Keep _MemberBox as is...

class _MemberBox extends StatefulWidget {
  final FamilyMember member;
  const _MemberBox(this.member);

  @override
  State<_MemberBox> createState() => _MemberBoxState();
}

class _MemberBoxState extends State<_MemberBox> {
  bool expanded = false;
  bool showSpouse = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.member;

    return CoupleCard(
      person: Person(
        name: m.name,
        phone: m.phone,
        email: m.email,
        isMarried: m.isMarried.toLowerCase() == 'true' ? true : false,
        gender: m.gender.toLowerCase() == 'male' ? Gender.male : Gender.female,
        spouse: Person(
          name: m.spouseName,
          phone: m.spouseWhatsapp,
          email: m.spouseEmail,

          gender: m.spouseGender.toLowerCase() == 'male'
              ? Gender.male
              : Gender.female,
          location: '',
          bloodGroup: m.spouseBloodGroup,
        ),
        location: '',
        bloodGroup: m.bloodGroup,
      ),
    );
  }
}
