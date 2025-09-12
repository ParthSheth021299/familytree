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

  // Graph buildGraphFromMembers(List<FamilyMember> members) {
  //   final graph = Graph();
  //   final Map<String, Node> nodeMap = {};
  //   final Map<String, FamilyMember> spouseMap = {}; // memberId -> spouse

  //   // Create root node (top-level family root)
  //   final rootNode = Node.Id('Jai Hatkesh');
  //   rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
  //   graph.addNode(rootNode);

  //   // Create nodes for all members
  //   for (var member in members) {
  //     final node = Node.Id(member.id);
  //     node.key = ValueKey(_MemberBox(member: member)); // spouse handled later
  //     graph.addNode(node);
  //     nodeMap[member.id] = node;

  //     // Track spouse if exists
  //     if (member.spouseId != null && member.spouseId!.isNotEmpty) {
  //       final spouse = members.firstWhere(
  //         (m) => m.id == member.spouseId,
  //         orElse: () => FamilyMember.empty(),
  //       );
  //       if (spouse.id.isNotEmpty) {
  //         spouseMap[member.id] = spouse;
  //         final spouseNode = Node.Id(spouse.id);
  //         spouseNode.key = ValueKey(_MemberBox(member: spouse));
  //         graph.addNode(spouseNode);
  //         nodeMap[spouse.id] = spouseNode;
  //       }
  //     }
  //   }

  //   // Build edges
  //   for (var member in members) {
  //     final node = nodeMap[member.id]!;

  //     if (member.isRoot == 'true') {
  //       // Connect root members to top-level root
  //       graph.addEdge(rootNode, node);
  //     } else if (member.parentId!.isNotEmpty &&
  //         nodeMap.containsKey(member.parentId)) {
  //       graph.addEdge(nodeMap[member.parentId]!, node);
  //     } else {
  //       // Fallback
  //       graph.addEdge(rootNode, node);
  //     }

  //     // Connect spouse at the same level
  //     final spouse = spouseMap[member.id];
  //     if (spouse != null && nodeMap.containsKey(spouse.id)) {
  //       if (member.parentId!.isNotEmpty &&
  //           nodeMap.containsKey(member.parentId)) {
  //         graph.addEdge(nodeMap[member.parentId]!, nodeMap[spouse.id]!);
  //       } else {
  //         graph.addEdge(rootNode, nodeMap[spouse.id]!);
  //       }
  //     }
  //   }

  //   return graph;
  // }
  // Graph buildGraphFromMembers(List<FamilyMember> members) {
  //   final graph = Graph();
  //   final Map<String, Node> nodeMap = {};

  //   // Create root node
  //   final rootNode = Node.Id('Jai Hatkesh');
  //   rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
  //   graph.addNode(rootNode);

  //   // Track which members have been added to avoid duplicates
  //   final Set<String> addedMemberIds = {};

  //   for (var member in members) {
  //     if (addedMemberIds.contains(member.id)) continue;

  //     final node = Node.Id(member.id);
  //     node.key = ValueKey(_MemberBox(member));
  //     graph.addNode(node);
  //     nodeMap[member.id] = node;
  //     addedMemberIds.add(member.id);

  //     // mark spouse as added so we don’t duplicate
  //     if (member.spouse != null && member.spouse!.id.isNotEmpty) {
  //       addedMemberIds.add(member.spouse!.id);
  //     }
  //   }

  //   // Build edges
  //   for (var member in members) {
  //     final node = nodeMap[member.id]!;

  //     if (member.isRoot ||
  //         member.parentId!.isEmpty ||
  //         !nodeMap.containsKey(member.parentId)) {
  //       graph.addEdge(rootNode, node);
  //     } else {
  //       graph.addEdge(nodeMap[member.parentId]!, node);
  //     }
  //   }

  //   return graph;
  // }
  // Graph buildGraphFromMembers(List<FamilyMember> members) {
  //   final graph = Graph();
  //   final Map<String, Node> nodeMap = {};
  //   final Set<String> addedMemberIds = {};

  //   // Root node
  //   final rootNode = Node.Id('Jai Hatkesh');
  //   rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
  //   graph.addNode(rootNode);

  //   for (var member in members) {
  //     if (addedMemberIds.contains(member.id)) continue;

  //     // Married members with spouse
  //     if (member.isMarried &&
  //         member.spouse != null &&
  //         (member.spouse?.id ?? '').isNotEmpty) {
  //       final coupleNode = Node.Id('${member.id}-${member.spouse!.id}');
  //       coupleNode.key = ValueKey(_MemberBox(member));
  //       graph.addNode(coupleNode);
  //       nodeMap[member.id] = coupleNode;
  //       nodeMap[member.spouse!.id] = coupleNode;

  //       addedMemberIds.add(member.id);
  //       addedMemberIds.add(member.spouse!.id);
  //     } else {
  //       // Single member
  //       final node = Node.Id(member.id);
  //       node.key = ValueKey(_MemberBox(member));
  //       graph.addNode(node);
  //       nodeMap[member.id] = node;
  //       addedMemberIds.add(member.id);
  //     }
  //   }

  //   // Build edges
  //   for (var member in members) {
  //     final node = nodeMap[member.id]!;
  //     if (member.isRoot ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty ||
  //         !nodeMap.containsKey(member.parentId)) {
  //       graph.addEdge(rootNode, node);
  //     } else {
  //       graph.addEdge(nodeMap[member.parentId!]!, node);
  //     }
  //   }

  //   return graph;
  // }
  // Graph buildGraphFromMembers(List<FamilyMember> members) {
  //   final graph = Graph();
  //   final Map<String, Node> nodeMap = {};
  //   final Set<String> addedMemberIds = {};

  //   // Root node
  //   final rootNode = Node.Id('Jai Hatkesh');
  //   rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
  //   graph.addNode(rootNode);

  //   for (var member in members) {
  //     if (addedMemberIds.contains(member.id)) continue;

  //     final spouse = member.spouse;

  //     // Check if spouse exists in members list
  //     final spouseExists =
  //         spouse != null && members.any((m) => m.id == spouse.id);

  //     if (member.isMarried && spouseExists) {
  //       // Both husband and spouse exist → create couple node
  //       final coupleNode = Node.Id('${member.id}-${spouse!.id}');
  //       coupleNode.key = ValueKey(
  //         _MemberBox(member),
  //       ); // Could customize to show spouse too
  //       graph.addNode(coupleNode);
  //       nodeMap[member.id] = coupleNode;
  //       nodeMap[spouse.id] = coupleNode;

  //       addedMemberIds.add(member.id);
  //       addedMemberIds.add(spouse.id);
  //     } else {
  //       // Only the member exists → single node
  //       final node = Node.Id(member.id);
  //       node.key = ValueKey(_MemberBox(member));
  //       graph.addNode(node);
  //       nodeMap[member.id] = node;
  //       addedMemberIds.add(member.id);
  //     }
  //   }

  //   // Build edges
  //   for (var member in members) {
  //     if (!nodeMap.containsKey(member.id))
  //       continue; // skip deleted/missing members

  //     final node = nodeMap[member.id]!;
  //     if (member.isRoot ||
  //         member.parentId == null ||
  //         member.parentId!.isEmpty ||
  //         !nodeMap.containsKey(member.parentId)) {
  //       graph.addEdge(rootNode, node);
  //     } else {
  //       graph.addEdge(nodeMap[member.parentId!]!, node);
  //     }
  //   }

  //   return graph;
  // }
  Graph buildGraphFromMembers(List<FamilyMember> members) {
    final graph = Graph();
    final Map<String, Node> nodeMap = {};
    final Set<String> addedMemberIds = {};

    // Root node
    final rootNode = Node.Id('Jai Hatkesh');
    rootNode.key = ValueKey(_labelBox("Jai Hatkesh"));
    graph.addNode(rootNode);

    // for (var member in members) {
    //   if (addedMemberIds.contains(member.id)) continue;

    //   final spouse = member.spouse;
    //   final spouseExists =
    //       spouse != null && members.any((m) => m.id == spouse.id);

    //   if (member.isMarried && spouseExists) {
    //     // Both exist → couple node
    //     final coupleNode = Node.Id('${member.id}-${spouse!.id}');
    //     coupleNode.key = ValueKey(_MemberBox(member, spouse));
    //     graph.addNode(coupleNode);
    //     nodeMap[member.id] = coupleNode;
    //     nodeMap[spouse.id] = coupleNode;

    //     addedMemberIds.add(member.id);
    //     addedMemberIds.add(spouse.id);
    //   } else {
    //     // Only member exists → single node
    //     final node = Node.Id(member.id);
    //     node.key = ValueKey(_MemberBox(member, spouse));
    //     graph.addNode(node);
    //     nodeMap[member.id] = node;
    //     addedMemberIds.add(member.id);
    //   }
    // }
    // for (var member in members) {
    //   if (addedMemberIds.contains(member.id)) continue;

    //   final spouse = member.spouse;
    //   final spouseExists =
    //       spouse != null && members.any((m) => m.id == spouse.id);

    //   if (member.isMarried && spouseExists) {
    //     // Both exist → couple node
    //     final coupleNode = Node.Id('${member.id}-${spouse!.id}');
    //     coupleNode.key = ValueKey(_MemberBox(member, spouse));
    //     graph.addNode(coupleNode);
    //     nodeMap[member.id] = coupleNode;
    //     nodeMap[spouse.id] = coupleNode;

    //     addedMemberIds.add(member.id);
    //     addedMemberIds.add(spouse.id);
    //   } else if (!member.isMarried && spouse == null) {
    //     // Only unmarried member → single node
    //     final node = Node.Id(member.id);
    //     node.key = ValueKey(_MemberBox(member, null));
    //     graph.addNode(node);
    //     nodeMap[member.id] = node;
    //     addedMemberIds.add(member.id);
    //   }
    //   // else → married but spouse missing → skip
    // }
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
        coupleNode.key = ValueKey(_MemberBox(member, spouse));
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
        node.key = ValueKey(_MemberBox(member, null));
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

// class _MemberBox extends StatefulWidget {
//   final FamilyMember member;
//   const _MemberBox(this.member);

//   @override
//   State<_MemberBox> createState() => _MemberBoxState();
// }

// class _MemberBoxState extends State<_MemberBox> {
//   bool expanded = false;
//   bool showSpouse = false;

//   @override
//   Widget build(BuildContext context) {
//     final m = widget.member;
//     print("WIFE NAME ${m.spouse?.name}");

//     return CoupleCard(
//       person: Person(
//         name: m.name,
//         phone: m.phone,
//         email: m.email,
//         isMarried: m.isMarried,
//         gender: m.gender.toLowerCase() == 'male' ? Gender.male : Gender.female,
//         spouse: m.spouse != null
//             ? Person(
//                 name: m.spouse!.name,
//                 phone: m.spouse!.phone,
//                 email: m.spouse!.email,
//                 gender: m.spouse!.gender.toLowerCase() == 'male'
//                     ? Gender.male
//                     : Gender.female,
//                 location: '',
//                 bloodGroup: m.spouse!.bloodGroup,
//               )
//             : null,

//         location: '',
//         bloodGroup: m.bloodGroup,
//       ),
//     );
//   }
// }
class _MemberBox extends StatefulWidget {
  final FamilyMember member;
  Spouse? spouse;
  _MemberBox(this.member, this.spouse);

  @override
  State<_MemberBox> createState() => _MemberBoxState();
}

class _MemberBoxState extends State<_MemberBox> {
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
                location: '',
                bloodGroup: m.spouse!.bloodGroup,
                isAlive: m.spouse!.isAlive,
              )
            : null,
        location: '',
        bloodGroup: m.bloodGroup,
        isAlive: m.isAlive,
      ),
    );
  }
}

// class _MemberBox extends StatelessWidget {
//   final FamilyMember member;

//   const _MemberBox({required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return CoupleCard(
//       person: Person(
//         name: member.name,
//         phone: member.phone,
//         email: member.email,
//         gender: member.gender.toLowerCase() == 'male'
//             ? Gender.male
//             : Gender.female,
//         isMarried: member.isMarried == 'true',
//         spouse: member.spouseId != null && member.spouseId!.isNotEmpty
//             ? Person(
//                 name: member.spouse?.name ?? '',
//                 phone: member.spouse?.whatsapp ?? '',
//                 email: member.spouse?.email ?? '',
//                 gender: member.spouse?.gender.toLowerCase() == 'male'
//                     ? Gender.male
//                     : Gender.female,
//                 location: member.spouse?.location ?? '',
//                 bloodGroup: member.spouse?.bloodGroup ?? '',
//               )
//             : null,
//         location: member.spouse?.location ?? '',
//         bloodGroup: member.bloodGroup,
//       ),
//     );
//   }
// }
// class _CoupleBox extends StatelessWidget {
//   final FamilyMember member;
//   const _CoupleBox({required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         _MemberCard(member: member), // your existing member card
//         // const SizedBox(width: 8),
//         // if (member.spouse != null)
//         _MemberCard(member: member.spouse!), // spouse card
//       ],
//     );
//   }
// }

// class _MemberCard extends StatelessWidget {
//   final dynamic member; // FamilyMember or Spouse
//   const _MemberCard({required this.member});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160,
//       height: 100,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: member.gender.toLowerCase() == 'male'
//             ? Colors.blue.shade100
//             : Colors.pink.shade100,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: member.gender.toLowerCase() == 'male'
//               ? Colors.blue
//               : Colors.pink,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             member.name,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//           Text(member.phone),
//         ],
//       ),
//     );
//   }
// }
