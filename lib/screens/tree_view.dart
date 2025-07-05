// import 'package:family_tree/service/google_sheet_service.dart';
// import 'package:flutter/material.dart';
// import 'package:graphview/GraphView.dart';
// import '../models/family_member.dart';

// class TreeViewScreen extends StatefulWidget {
//   const TreeViewScreen({Key? key}) : super(key: key);

//   @override
//   State<TreeViewScreen> createState() => _TreeViewScreenState();
// }

// class _TreeViewScreenState extends State<TreeViewScreen> {
//   final Graph graph = Graph();
//   final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
//   final GoogleSheetsService _service = GoogleSheetsService();

//   bool isLoading = true;
//   List<FamilyMember> members = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     try {
//       members = await _service.fetchFamilyData();
//       buildTree();
//     } catch (e) {
//       print("Error loading tree data: \$e");
//     }
//     setState(() => isLoading = false);
//   }

//   void buildTree() {
//     graph.nodes.clear();
//     graph.edges.clear();

//     final Map<String, Node> nodeMap = {};

//     // Create Dahibanagar root node
//     final rootNode = Node.Id("Dahibanagar");
//     final rootMember = FamilyMember(
//       id: "Dahibanagar",
//       parentId: "",
//       name: "Dahibanagar",
//       gender: "",
//       bloodGroup: "",
//       whatsapp: "",
//       maritalStatus: "",
//       spouseName: "",
//       hasChildren: 'false',
//       email: "",
//       location: "",
//       photoUrl: "",
//       houseRoot: "Dahibanagar",
//       isRoot: 'true',
//       dob: '', spousePhotoUrl: '', spouseWhatsapp: '', spouseBloodGroup: '', spouseEmail: '', spouseLocation: ''
//     );
//     rootNode.key = ValueKey(_MemberBox(rootMember));
//     graph.addNode(rootNode);
//     nodeMap[rootMember.id] = rootNode;

//     for (var member in members) {
//       final memberNode = Node.Id(member.id);
//       memberNode.key = ValueKey(_MemberBox(member));
//       graph.addNode(memberNode);
//       nodeMap[member.id] = memberNode;

//       final parentId = member.parentId.trim();
//       if (parentId.isNotEmpty && nodeMap.containsKey(parentId)) {
//         graph.addEdge(nodeMap[parentId]!, memberNode);
//       } else {
//         graph.addEdge(rootNode, memberNode);
//       }
//     }
//   }

//   void buildFilteredTree(List<FamilyMember> filteredMembers) {
//     graph.nodes.clear();
//     graph.edges.clear();
//     final Map<String, Node> nodeMap = {};

//     for (var member in filteredMembers) {
//       final memberNode = Node.Id(member.id);
//       memberNode.key = ValueKey(_MemberBox(member));
//       graph.addNode(memberNode);
//       nodeMap[member.id] = memberNode;

//       final parentId = member.parentId.trim();
//       if (parentId.isNotEmpty && nodeMap.containsKey(parentId)) {
//         graph.addEdge(nodeMap[parentId]!, memberNode);
//       }
//     }
//   }

//  void filterTreeByName(String name) {
//   final member = members.firstWhere(
//     (m) => m.name.toLowerCase() == name.toLowerCase(),
//     orElse: () => FamilyMember(id: '', parentId: '', name: '', houseRoot: '', gender: '', bloodGroup: '', whatsapp: '', maritalStatus: '', spouseName: '', hasChildren: '', email: '', location: '', photoUrl: '', isRoot: '', dob: '', spousePhotoUrl: '', spouseWhatsapp: '', spouseBloodGroup: '', spouseEmail: '', spouseLocation: ''),
//   );

//   if (member.id.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Member not found")),
//     );
//     return;
//   }

//   FamilyMember? findMemberById(String id) {
//     try {
//       return members.firstWhere((m) => m.id == id);
//     } catch (_) {
//       return null;
//     }
//   }

//   List<FamilyMember> lineage = [];
//   FamilyMember? current = member;
//   while (current != null) {
//     lineage.insert(0, current);
//     current = findMemberById(current.parentId);
//   }

//   setState(() => buildFilteredTree(lineage));
// }

//   @override
//   Widget build(BuildContext context) {
//     builder
//       ..siblingSeparation = (20)
//       ..levelSeparation = (50)
//       ..subtreeSeparation = (30)
//       ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Family Tree")),
//       body: Builder(
//         builder: (_) {
//           if (isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (graph.nodeCount() == 0) {
//             return const Center(child: Text('No members in the tree'));
//           }

//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           labelText: 'Search by Name',
//                           border: const OutlineInputBorder(),
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.search),
//                             onPressed: () => filterTreeByName(searchController.text.trim()),
//                           ),
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.clear),
//                       onPressed: () {
//                         searchController.clear();
//                         setState(() => buildTree());
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: InteractiveViewer(
//                   constrained: false,
//                   boundaryMargin: const EdgeInsets.all(100),
//                   minScale: 0.01,
//                   maxScale: 5.0,
//                   child: GraphView(
//                     graph: graph,
//                     algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
//                     builder: (Node node) {
//                       return node.key?.value as Widget;
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _MemberBox extends StatefulWidget {
//   final FamilyMember member;
//   const _MemberBox(this.member, {Key? key}) : super(key: key);

//   @override
//   State<_MemberBox> createState() => _MemberBoxState();
// }

// class _MemberBoxState extends State<_MemberBox> {
//   bool expanded = false;
//   bool showSpouse = false;
//   bool imageLoaded = false;

//   @override
//   Widget build(BuildContext context) {
//     final m = widget.member;

//     return GestureDetector(
//       onTap: () => setState(() => expanded = !expanded),
//       child: SizedBox(
//         width: 220,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: expanded ? Colors.blue.shade50 : Colors.green.shade50,
//             border: Border.all(color: Colors.green.shade400),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 6,
//                 offset: const Offset(2, 2),
//               )
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   ClipOval(
//                     child: m.photoUrl.isNotEmpty
//                         ? Image.network(
//                             m.photoUrl,
//                             height: 40,
//                             width: 40,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return SizedBox(
//                                 height: 40,
//                                 width: 40,
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     value: loadingProgress.expectedTotalBytes != null
//                                         ? loadingProgress.cumulativeBytesLoaded /
//                                             (loadingProgress.expectedTotalBytes ?? 1)
//                                         : null,
//                                   ),
//                                 ),
//                               );
//                             },
//                             errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 40),
//                           )
//                         : const Icon(Icons.person, size: 40),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       m.name,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//               if (expanded) ...[
//                 const Divider(height: 10),
//                 if (m.bloodGroup.isNotEmpty) Text("Blood Group: ${m.bloodGroup}"),
//                 if (m.email.isNotEmpty) Text("Email: ${m.email}"),
//                 if (m.location.isNotEmpty) Text("Location: ${m.location}"),
//                 if (m.whatsapp.isNotEmpty) Text("WhatsApp: ${m.whatsapp}"),
//                 if (m.hasChildren == 'true') const Text("Children: Yes"),
//                 if (m.spouseName.isNotEmpty) ...[
//                   const Divider(),
//                   TextButton(
//                     onPressed: () => setState(() => showSpouse = !showSpouse),
//                     child: Text(showSpouse ? "Hide Spouse Details" : "Show Spouse Details"),
//                   ),
//                   if (showSpouse)
//                     Container(
//                       margin: const EdgeInsets.only(top: 6),
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.pink.shade50,
//                         borderRadius: BorderRadius.circular(6),
//                         border: Border.all(color: Colors.pink.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Spouse: ${m.spouseName}", style: const TextStyle(fontWeight: FontWeight.bold)),
//                           if (m.spouseWhatsapp.isNotEmpty) Text("WhatsApp: ${m.spouseWhatsapp}"),
//                           if (m.spouseEmail.isNotEmpty) Text("Email: ${m.spouseEmail}"),
//                           if (m.spouseBloodGroup.isNotEmpty) Text("Blood Group: ${m.spouseBloodGroup}"),
//                           if (m.spouseLocation.isNotEmpty) Text("Location: ${m.spouseLocation}"),
//                           if (m.spousePhotoUrl.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: ClipOval(
//                                 child: Image.network(
//                                   m.spousePhotoUrl,
//                                   height: 60,
//                                   width: 60,
//                                   fit: BoxFit.cover,
//                                   loadingBuilder: (context, child, progress) {
//                                     if (progress == null) return child;
//                                     return const SizedBox(
//                                       height: 60,
//                                       width: 60,
//                                       child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
//                                     );
//                                   },
//                                   errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 60),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     )
//                 ]
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// file: tree_view_screen.dart

// TreeViewScreen.dart

import 'package:family_tree/screens/filter_drop_down_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import '../models/family_member.dart';
import '../service/google_sheet_service.dart';
// <-- Make sure to import this

class TreeViewScreen extends StatefulWidget {
  const TreeViewScreen({Key? key}) : super(key: key);

  @override
  State<TreeViewScreen> createState() => _TreeViewScreenState();
}

class _TreeViewScreenState extends State<TreeViewScreen> {
  final Graph graph = Graph();
  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final GoogleSheetsService _service = GoogleSheetsService();

  bool isLoading = true;
  List<FamilyMember> allMembers = [];
  List<FamilyMember> filteredMembers = [];
  TextEditingController searchController = TextEditingController();
  Set<String> selectedFilters = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    allMembers = await _service.fetchFamilyData();
    filteredMembers = allMembers;
    buildTree(filteredMembers);
    setState(() => isLoading = false);
  }

  void buildTree(List<FamilyMember> members) {
    graph.nodes.clear();
    graph.edges.clear();
    final nodeMap = <String, Node>{};

    final rootNode = Node.Id("Dahibanagar");
    final rootMember = FamilyMember(
      id: "Dahibanagar",
      parentId: "",
      name: "Dahibanagar",
      gender: "",
      bloodGroup: "",
      whatsapp: "",
      maritalStatus: "",
      spouseName: "",
      hasChildren: 'false',
      email: "",
      location: "",
      photoUrl: "",
      houseRoot: "Dahibanagar",
      isRoot: 'true',
      dob: '',
      spousePhotoUrl: '',
      spouseWhatsapp: '',
      spouseBloodGroup: '',
      spouseEmail: '',
      spouseLocation: '',
    );
    rootNode.key = ValueKey(_MemberBox(rootMember));
    graph.addNode(rootNode);
    nodeMap[rootMember.id] = rootNode;

    for (var member in members) {
      final memberNode = Node.Id(member.id);
      memberNode.key = ValueKey(_MemberBox(member));
      graph.addNode(memberNode);
      nodeMap[member.id] = memberNode;

      final parentId = member.parentId.trim();
      if (parentId.isNotEmpty && nodeMap.containsKey(parentId)) {
        graph.addEdge(nodeMap[parentId]!, memberNode);
      } else {
        graph.addEdge(rootNode, memberNode);
      }
    }
  }

  void searchTree(String name) {
    final member = allMembers.firstWhere(
      (m) => m.name.toLowerCase() == name.toLowerCase(),
      orElse: () => FamilyMember(
        id: '',
        parentId: '',
        name: '',
        houseRoot: '',
        gender: '',
        bloodGroup: '',
        whatsapp: '',
        maritalStatus: '',
        spouseName: '',
        hasChildren: '',
        email: '',
        location: '',
        photoUrl: '',
        isRoot: '',
        dob: '',
        spousePhotoUrl: '',
        spouseWhatsapp: '',
        spouseBloodGroup: '',
        spouseEmail: '',
        spouseLocation: '',
      ),
    );

    if (member.id.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Member not found")));
      return;
    }

    List<FamilyMember> lineage = [];
    FamilyMember? current = member;
    while (current != null && current.id.isNotEmpty) {
      lineage.insert(0, current);
      current = allMembers.firstWhere(
        (m) => m.id == current!.parentId,
        orElse: () => FamilyMember(
          id: '',
          parentId: '',
          name: '',
          houseRoot: '',
          gender: '',
          bloodGroup: '',
          whatsapp: '',
          maritalStatus: '',
          spouseName: '',
          hasChildren: '',
          email: '',
          location: '',
          photoUrl: '',
          isRoot: '',
          dob: '',
          spousePhotoUrl: '',
          spouseWhatsapp: '',
          spouseBloodGroup: '',
          spouseEmail: '',
          spouseLocation: '',
        ),
      );
    }

    buildTree(lineage);
    setState(() {});
  }

  void clearFilters() {
    selectedFilters.clear();
    filteredMembers = allMembers;
    buildTree(filteredMembers);
    setState(() {});
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 1,
        child: FilterDropdownSheet(
          members: allMembers,
          selected: selectedFilters,
          onApply: (filters) {
            selectedFilters = filters;

            final genders = {'male', 'female'};
            final bloodGroups = allMembers.map((m) => m.bloodGroup).toSet();
            final houseRoots = allMembers.map((m) => m.houseRoot).toSet();
            final hasChildrenOptions = {'true', 'false'};

            final genderFilter = filters.intersection(genders);
            final bloodGroupFilter = filters.intersection(bloodGroups);
            final houseRootFilter = filters.intersection(houseRoots);
            final hasChildrenFilter = filters.intersection(hasChildrenOptions);

            filteredMembers = allMembers.where((m) {
              final matchGender =
                  genderFilter.isEmpty || genderFilter.contains(m.gender);
              final matchBlood =
                  bloodGroupFilter.isEmpty ||
                  bloodGroupFilter.contains(m.bloodGroup);
              final matchRoot =
                  houseRootFilter.isEmpty ||
                  houseRootFilter.contains(m.houseRoot);
              final matchChildren =
                  hasChildrenFilter.isEmpty ||
                  hasChildrenFilter.contains(m.hasChildren);
              return matchGender && matchBlood && matchRoot && matchChildren;
            }).toList();

            buildTree(filteredMembers);
            setState(() {});
          },
          onClear: clearFilters,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    builder
      ..siblingSeparation = 20
      ..levelSeparation = 50
      ..subtreeSeparation = 30
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return Scaffold(
      appBar: AppBar(title: const Text("Family Tree")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search by name',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () =>
                                searchTree(searchController.text.trim()),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              buildTree(allMembers);
                              setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.filter_list),
                            onPressed: openFilterSheet,
                          ),
                        ],
                      ),
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
                        builder,
                        TreeEdgeRenderer(builder),
                      ),
                      builder: (Node node) => node.key?.value as Widget,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:graphview/GraphView.dart';
// import '../models/family_member.dart';
// import '../service/google_sheet_service.dart';

// class TreeViewScreen extends StatefulWidget {
//   const TreeViewScreen({super.key});

//   @override
//   State<TreeViewScreen> createState() => _TreeViewScreenState();
// }

// class _TreeViewScreenState extends State<TreeViewScreen> {
//   final Graph graph = Graph();
//   final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
//   final GoogleSheetsService _service = GoogleSheetsService();

//   bool isLoading = true;
//   List<FamilyMember> allMembers = [];
//   String selectedBranch = 'Dahibanagar'; // default
//   final List<String> roots = ['Dahibanagar', 'Kubernagar'];

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     setState(() => isLoading = true);
//     allMembers = await _service.fetchFamilyData();
//     buildTree(selectedBranch);
//     setState(() => isLoading = false);
//   }

//   void buildTree(String branchRoot) {
//     graph.nodes.clear();
//     graph.edges.clear();
//     final nodeMap = <String, Node>{};

//     // Main root "Society"
//     final societyNode = Node.Id("Society");
//     final society = FamilyMember(
//       id: "Society",
//       name: "Society",
//       houseRoot: '',
//       parentId: '',
//       gender: '',
//       bloodGroup: '',
//       whatsapp: '',
//       maritalStatus: '',
//       spouseName: '',
//       hasChildren: '',
//       email: '',
//       location: '',
//       photoUrl: '',
//       isRoot: '',
//       dob: '',
//       spousePhotoUrl: '',
//       spouseWhatsapp: '',
//       spouseBloodGroup: '',
//       spouseEmail: '',
//       spouseLocation: '',
//     );
//     societyNode.key = ValueKey(_buildNodeBox(society));
//     graph.addNode(societyNode);
//     nodeMap["Society"] = societyNode;

//     for (var root in roots) {
//       final rootNode = Node.Id(root);
//       final rootMember = FamilyMember(
//         id: root,
//         name: root,
//         parentId: "Society",
//         houseRoot: root,
//         gender: '',
//         bloodGroup: '',
//         whatsapp: '',
//         maritalStatus: '',
//         spouseName: '',
//         hasChildren: '',
//         email: '',
//         location: '',
//         photoUrl: '',
//         isRoot: '',
//         dob: '',
//         spousePhotoUrl: '',
//         spouseWhatsapp: '',
//         spouseBloodGroup: '',
//         spouseEmail: '',
//         spouseLocation: '',
//       );
//       rootNode.key = ValueKey(_buildNodeBox(rootMember));
//       graph.addNode(rootNode);
//       graph.addEdge(societyNode, rootNode);
//       nodeMap[root] = rootNode;
//     }

//     final members = allMembers.where((m) => m.houseRoot == branchRoot).toList();

//     for (var member in members) {
//       final node = Node.Id(member.id);
//       node.key = ValueKey(_buildNodeBox(member));
//       graph.addNode(node);
//       nodeMap[member.id] = node;

//       if (member.parentId.isNotEmpty && nodeMap.containsKey(member.parentId)) {
//         graph.addEdge(nodeMap[member.parentId]!, node);
//       } else {
//         graph.addEdge(
//           nodeMap[branchRoot]!,
//           node,
//         ); // attach to Dahibanagar/Kubernagar root
//       }
//     }
//   }

//   Widget _buildNodeBox(FamilyMember m) {
//     return Card(
//       color: Colors.green.shade50,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               backgroundImage: m.photoUrl.isNotEmpty
//                   ? NetworkImage(m.photoUrl)
//                   : const AssetImage('assets/images/avatar.jpg')
//                         as ImageProvider,
//               radius: 18,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               m.name,
//               style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     builder
//       ..siblingSeparation = 20
//       ..levelSeparation = 50
//       ..subtreeSeparation = 30
//       ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Family Tree"),
//         actions: [
//           DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: selectedBranch,
//               onChanged: (value) {
//                 if (value != null) {
//                   setState(() {
//                     selectedBranch = value;
//                     buildTree(value);
//                   });
//                 }
//               },
//               items: roots
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : InteractiveViewer(
//               boundaryMargin: const EdgeInsets.all(200),
//               constrained: false,
//               minScale: 0.1,
//               maxScale: 5,
//               child: GraphView(
//                 graph: graph,
//                 algorithm: BuchheimWalkerAlgorithm(
//                   builder,
//                   TreeEdgeRenderer(builder),
//                 ),
//                 builder: (Node node) => node.key?.value as Widget,
//               ),
//             ),
//     );
//   }
// }

class _MemberBox extends StatefulWidget {
  final FamilyMember member;
  const _MemberBox(this.member, {Key? key}) : super(key: key);

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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: expanded ? Colors.blue.shade200 : Colors.grey.shade300,
              width: 1.2,
            ),
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
                  _infoRow("🩸 Blood Group", m.bloodGroup),
                if (m.location.isNotEmpty) _infoRow("📍 Location", m.location),
                if (m.email.isNotEmpty) _infoRow("📧 Email", m.email),
                if (m.whatsapp.isNotEmpty) _infoRow("📱 WhatsApp", m.whatsapp),
                if (m.hasChildren == 'true') _infoRow("👶 Children", "Yes"),
                if (m.spouseName.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => setState(() => showSpouse = !showSpouse),
                    icon: Icon(
                      showSpouse ? Icons.visibility_off : Icons.visibility,
                    ),
                    label: Text(showSpouse ? "Hide Spouse" : "Show Spouse"),
                  ),
                if (showSpouse)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      _infoRow("❤️ Spouse", m.spouseName),
                      if (m.spouseEmail.isNotEmpty)
                        _infoRow("📧 Email", m.spouseEmail),
                      if (m.spouseWhatsapp.isNotEmpty)
                        _infoRow("📱 WhatsApp", m.spouseWhatsapp),
                      if (m.spouseBloodGroup.isNotEmpty)
                        _infoRow("🩸 Blood Group", m.spouseBloodGroup),
                      if (m.spouseLocation.isNotEmpty)
                        _infoRow("📍 Location", m.spouseLocation),
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
