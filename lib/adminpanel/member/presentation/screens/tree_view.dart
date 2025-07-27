import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
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

  Node societyNode = Node.Id('Society');
  Node dahibanagarNode = Node.Id('Dahibanagar');
  Node kubernagarNode = Node.Id('Kubernagar');

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().subscribeToMembers();
  }

  Graph buildGraphFromMembers(List<FamilyMember> members) {
    final graph = Graph();
    final Map<String, Node> nodeMap = {};

    // Top-level society and roots
    societyNode = Node.Id('Society');
    dahibanagarNode = Node.Id('Dahibanagar');
    kubernagarNode = Node.Id('Kubernagar');

    graph.addNode(societyNode..key = ValueKey(_labelBox("Society")));
    graph.addNode(dahibanagarNode..key = ValueKey(_labelBox("Dahibanagar")));
    graph.addNode(kubernagarNode..key = ValueKey(_labelBox("Kubernagar")));
    graph.addEdge(societyNode, dahibanagarNode);
    graph.addEdge(societyNode, kubernagarNode);

    for (var member in members) {
      final node = Node.Id(member.id);
      node.key = ValueKey(_MemberBox(member));
      graph.addNode(node);
      nodeMap[member.id] = node;
    }

    for (var member in members) {
      final node = nodeMap[member.id]!;

      if (member.isRoot == 'true') {
        final rootNode = member.mainRoot.toLowerCase() == 'dahibanagar'
            ? dahibanagarNode
            : kubernagarNode;
        graph.addEdge(rootNode, node);
      } else if (member.parentId.isNotEmpty &&
          nodeMap.containsKey(member.parentId)) {
        graph.addEdge(nodeMap[member.parentId]!, node);
      } else {
        final fallback = member.mainRoot.toLowerCase() == 'dahibanagar'
            ? dahibanagarNode
            : kubernagarNode;
        graph.addEdge(fallback, node);
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
  const _MemberBox(this.member, {super.key});

  @override
  State<_MemberBox> createState() => _MemberBoxState();
}

class _MemberBoxState extends State<_MemberBox> {
  bool expanded = false;
  bool showSpouse = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.member;
    final bool hasPhoto = m.photoUrl.isNotEmpty;

    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 500 ? 200 : 240,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: expanded ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: expanded ? Colors.blue.shade200 : Colors.grey.shade300,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: expanded ? 34 : 28,
                backgroundImage: hasPhoto
                    ? NetworkImage(m.photoUrl)
                    : const AssetImage('assets/images/avatar.jpg')
                          as ImageProvider,
              ),
              const SizedBox(height: 8),
              Text(
                m.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                textAlign: TextAlign.center,
              ),
              if (expanded) ...[
                const SizedBox(height: 10),
                const Divider(),
                if (m.bloodGroup.isNotEmpty)
                  _infoRow(
                    "🩸 ${AppLocalizations.of(context)!.bloodGroup}",
                    m.bloodGroup,
                  ),
                if (m.location.isNotEmpty)
                  _infoRow(
                    "📍 ${AppLocalizations.of(context)!.location}",
                    m.location,
                  ),
                if (m.email.isNotEmpty)
                  _infoRow(
                    "📧 ${AppLocalizations.of(context)!.email}",
                    m.email,
                  ),
                if (m.phone.isNotEmpty)
                  _infoRow(
                    "📱 ${AppLocalizations.of(context)!.whatsapp}",
                    m.phone,
                  ),
                if (m.hasChildren == 'true')
                  _infoRow(
                    "👶 ${AppLocalizations.of(context)!.children}",
                    "Yes",
                  ),
                if (m.spouseName.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => setState(() => showSpouse = !showSpouse),
                    icon: Icon(
                      showSpouse ? Icons.visibility_off : Icons.visibility,
                    ),
                    label: Text(
                      showSpouse
                          ? AppLocalizations.of(context)!.hideSpouse
                          : AppLocalizations.of(context)!.showSpouse,
                    ),
                  ),
                if (showSpouse)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      _infoRow(
                        "❤️ ${AppLocalizations.of(context)!.spouse}",
                        m.spouseName,
                      ),
                      if (m.spouseEmail.isNotEmpty)
                        _infoRow(
                          "📧 ${AppLocalizations.of(context)!.email}",
                          m.spouseEmail,
                        ),
                      if (m.spouseWhatsapp.isNotEmpty)
                        _infoRow(
                          "📱 ${AppLocalizations.of(context)!.whatsapp}",
                          m.spouseWhatsapp,
                        ),
                      if (m.spouseBloodGroup.isNotEmpty)
                        _infoRow(
                          "🩸 ${AppLocalizations.of(context)!.bloodGroup}",
                          m.spouseBloodGroup,
                        ),
                      if (m.spouseLocation.isNotEmpty)
                        _infoRow(
                          "📍 ${AppLocalizations.of(context)!.location}",
                          m.spouseLocation,
                        ),
                      if (m.spousePhotoUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(m.spousePhotoUrl),
                          ),
                        ),
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
