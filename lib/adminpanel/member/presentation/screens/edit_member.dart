import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMemberScreen extends StatefulWidget {
  final FamilyMember member;

  const EditMemberScreen({super.key, required this.member});

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  // Spouse
  TextEditingController spouseNameController = TextEditingController();
  TextEditingController spousePhotoUrlController = TextEditingController();
  TextEditingController spouseWhatsappController = TextEditingController();
  TextEditingController spouseBloodGroupController = TextEditingController();
  TextEditingController spouseEmailController = TextEditingController();
  TextEditingController spouseLocationController = TextEditingController();

  String? selectedGender;
  String? selectedMainRoot;
  bool isMarried = false;
  bool isRoot = false;
  bool hasChildren = false;
  String? status; // in FamilyMember model
  String? isAlive; // default true for alive

  final List<String> genderOptions = ['male', 'female'];

  List<FamilyMember>? allMembers;

  String? selectedParentId;
  List<FamilyMember> parentList = [];

  @override
  void initState() {
    super.initState();
    fetchMemberData();
    selectedParentId = widget.member.parentId.isNotEmpty
        ? widget.member.parentId
        : null;
    loadParents();
  }

  Future<void> fetchMemberData() async {
    final doc = await FirebaseFirestore.instance
        .collection('family_members')
        .doc(widget.member.id)
        .get();

    if (doc.exists) {
      final member = FamilyMember.fromJson(doc.data()!);

      // Now assign all values
      setState(() {
        nameController = TextEditingController(text: member.name);
        phoneController = TextEditingController(text: member.phone);
        emailController = TextEditingController(text: member.email);
        // locationController = TextEditingController(text: member.location);
        bloodGroupController = TextEditingController(text: member.bloodGroup);
        dobController = TextEditingController(text: member.dob);

        spouseNameController = TextEditingController(text: member.spouseName);
        spouseEmailController = TextEditingController(
          text: member.spouseEmail == 'null' ? '' : member.spouseEmail,
        );
        spouseLocationController = TextEditingController(
          text: member.spouseLocation == 'null' ? '' : member.spouseLocation,
        );
        spouseWhatsappController = TextEditingController(
          text: member.spouseWhatsapp == 'null' ? '' : member.spouseWhatsapp,
        );
        spouseBloodGroupController = TextEditingController(
          text: member.spouseBloodGroup == 'null'
              ? ''
              : member.spouseBloodGroup,
        );

        selectedGender = member.gender;
        selectedMainRoot = member.mainRoot;
        isMarried = member.isMarried == 'true';
        isRoot = member.isRoot == 'true';
        hasChildren = member.hasChildren == 'true';
      });
    }
  }

  void loadParents() async {
    final fetchedList = await fetchParentListByMainRoot(
      mainRoot: widget.member.mainRoot, // assuming you're editing a member
      excludeMemberId: widget.member.id,
    );

    setState(() {
      parentList = fetchedList;
    });
  }

  Future<List<FamilyMember>> fetchParentListByMainRoot({
    required String mainRoot,
    required String excludeMemberId,
  }) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .where('mainRoot', isEqualTo: mainRoot) // "houseRoot" = "mainRoot"
        .get();

    return querySnapshot.docs
        .map((doc) => FamilyMember.fromJson(doc.data()))
        .where((member) => member.id != excludeMemberId)
        .toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    locationController.dispose();
    bloodGroupController.dispose();
    dobController.dispose();
    spouseNameController.dispose();
    spousePhotoUrlController.dispose();
    spouseWhatsappController.dispose();
    spouseBloodGroupController.dispose();
    spouseEmailController.dispose();
    spouseLocationController.dispose();
    super.dispose();
  }

  Future<FamilyMember?> getFamilyRoot(String memberId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('family_members')
        .doc(memberId)
        .get();
    if (!doc.exists) return null;

    FamilyMember member = FamilyMember.fromJson(
      doc.data() as Map<String, dynamic>,
    );
    if (member.isRoot == "true") {
      return member;
    } else {
      return await getFamilyRoot(member.parentId);
    }
  }

  Future<List<FamilyMember>> getValidParentListFor(String memberId) async {
    final root = await getFamilyRoot(memberId);
    if (root == null) return [];

    final allMembersSnapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .get();

    final allMembers = allMembersSnapshot.docs
        .map((doc) => FamilyMember.fromJson(doc.data() as Map<String, dynamic>))
        .toList();

    // Recursive traversal from root to get all family members under that root
    List<FamilyMember> collectDescendants(String parentId) {
      List<FamilyMember> children = allMembers
          .where((m) => m.parentId == parentId)
          .toList();

      List<FamilyMember> descendants = [];
      for (var child in children) {
        descendants.add(child);
        descendants.addAll(collectDescendants(child.id));
      }

      return descendants;
    }

    List<FamilyMember> result = [root, ...collectDescendants(root.id)];
    return result;
  }

  Future<List<FamilyMember>> getFamilyBranchMembers(String rootId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .where(
          'mainRoot',
          isEqualTo: rootId,
        ) // OR use a virtual "rootParent" if stored
        .get();

    return snapshot.docs
        .map((doc) => FamilyMember.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  void _updateMember() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'location': locationController.text,
        'bloodGroup': bloodGroupController.text,
        'dob': dobController.text,
        'gender': selectedGender,
        'mainRoot': selectedMainRoot,
        'isMarried': isMarried.toString(),
        'isRoot': isRoot.toString(),
        'spouseName': isMarried ? spouseNameController.text : '',
        'spousePhotoUrl': isMarried ? spousePhotoUrlController.text : '',
        'spouseWhatsapp': isMarried ? spouseWhatsappController.text : '',
        'spouseBloodGroup': isMarried ? spouseBloodGroupController.text : '',
        'spouseEmail': isMarried ? spouseEmailController.text : '',
        'spouseLocation': isMarried ? spouseLocationController.text : '',
        'parentId': selectedParentId ?? widget.member.parentId,
        'isAlive': isAlive,
      };

      await FirebaseFirestore.instance
          .collection('family_members')
          .doc(widget.member.id)
          .update(updatedData);

      showToast(AppLocalizations.of(context)!.familyMemberAdded);

      Navigator.pop(context);
    }
  }

  Widget _buildSpouseFields() {
    if (!isMarried) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(height: 20),
        TextFormField(
          controller: spouseNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.spouseName,
          ),
        ),

        SizedBox(height: 20),
        TextFormField(
          controller: spouseWhatsappController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.spouseWhatsapp,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: spouseBloodGroupController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.spouseBloodGroup,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: spouseEmailController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.spouseEmail,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: spouseLocationController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.spouseLocation,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.yourName,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderOptions.map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.gender,
              ),
              onChanged: (val) => setState(() => selectedGender = val),
            ),
            SizedBox(height: 20),
            // DropdownButtonFormField<String>(
            //   value: selectedMainRoot,
            //   items: mainRootOptions.map((root) {
            //     return DropdownMenuItem(value: root, child: Text(root));
            //   }).toList(),
            //   decoration: InputDecoration(
            //     labelText: AppLocalizations.of(context)!.mainRoot,
            //   ),
            //   onChanged: (val) => setState(() => selectedMainRoot = val),
            // ),
            SizedBox(height: 20),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phoneNumber,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.location,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: bloodGroupController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.bloodGroup,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: dobController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.dob,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              value: isMarried,
              onChanged: (val) => setState(() => isMarried = val),
              title: Text(AppLocalizations.of(context)!.isMarried),
            ),

            _buildSpouseFields(),
            SizedBox(height: 20),
            SwitchListTile(
              value: isRoot,
              onChanged: (val) => setState(() => isRoot = val),
              title: Text(AppLocalizations.of(context)!.isInternalRoot),
            ),
            SizedBox(height: 20),

            // SwitchListTile(
            //   title: const Text('Alive'),
            //   value: isAlive == 'true' ? true : false,
            //   onChanged: (value) {
            //     setState(() {
            //       isAlive = value.toString();
            //     });
            //   },
            //   secondary: Icon(
            //     isAlive == true ? Icons.favorite : Icons.favorite_border,
            //     color: isAlive == true ? Colors.green : Colors.red,
            //   ),
            // ),
            SizedBox(height: 10),

            // SwitchListTile(
            //   title: Text(AppLocalizations.of(context)!.hasChildren),
            //   value: hasChildren,
            //   onChanged: (value) {
            //     setState(() {
            //       hasChildren = value;
            //     });
            //   },
            // ),
            // SizedBox(height: 10),
            ParentDropdown(
              currentMemberId: widget.member.id,
              selectedParentId: widget.member.parentId,
              onChanged: (newParentId) {
                // handle parent change
              },
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateMember,
              child: Text(AppLocalizations.of(context)!.update),
            ),
          ],
        ),
      ),
    );
  }

  String getNameById(String id) {
    return allMembers
            ?.firstWhere(
              (m) => m.parentId == id,
              orElse: () => FamilyMember.empty(),
            )
            .name ??
        '';
  }

  void handleParentChanged(String? newParentId) {
    setState(() {
      selectedParentId = newParentId;
    });
  }
}

class ParentDropdown extends StatefulWidget {
  final String currentMemberId;
  final String? selectedParentId;
  final Function(String?) onChanged;

  const ParentDropdown({
    super.key,
    required this.currentMemberId,
    required this.selectedParentId,
    required this.onChanged,
  });

  @override
  State<ParentDropdown> createState() => _ParentDropdownState();
}

class _ParentDropdownState extends State<ParentDropdown> {
  List<DropdownMenuItem<String>> _parentItems = [];
  String? _selectedParentId;

  @override
  void initState() {
    super.initState();
    _loadFamilyBranchParents();
  }

  Future<void> _loadFamilyBranchParents() async {
    final allDocsSnapshot = await FirebaseFirestore.instance
        .collection('family_members')
        .get();

    final allMembers = allDocsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? '',
        'parentId': data['parentId'],
        'isRoot': data['isRoot'] ?? 'false',
      };
    }).toList();

    // Step 1: Get current member
    final currentMember = allMembers.firstWhere(
      (m) => m['id'] == widget.currentMemberId,
      orElse: () => {},
    );

    if (currentMember.isEmpty) return;

    // Step 2: Find internal root of current member
    Map<String, dynamic>? getRoot(Map<String, dynamic> member) {
      if (member['isRoot'] == 'true' || member['parentId'] == null) {
        return member;
      }
      final parent = allMembers.firstWhere(
        (m) => m['id'] == member['parentId'],
        orElse: () => {},
      );
      if (parent.isEmpty) return member;
      return getRoot(parent);
    }

    final rootMember = getRoot(currentMember);
    final rootId = rootMember?['id'];

    // Step 3: Recursively collect descendants of the root
    List<Map<String, dynamic>> collectDescendants(String parentId) {
      final children = allMembers
          .where((m) => m['parentId'] == parentId)
          .toList();
      List<Map<String, dynamic>> result = [...children];
      for (var child in children) {
        result.addAll(collectDescendants(child['id']));
      }
      return result;
    }

    final familyBranch = [rootMember, ...collectDescendants(rootId)];

    // Step 4: Build dropdown items excluding the current member
    final dropdownItems = familyBranch
        .where((m) => m?['id'] != widget.currentMemberId)
        .map((m) {
          return DropdownMenuItem<String>(
            value: m?['id'],
            child: Text(m?['name']),
          );
        })
        .toList();

    setState(() {
      _parentItems = dropdownItems;
      _selectedParentId = widget.selectedParentId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: _parentItems.any((item) => item.value == _selectedParentId)
          ? _selectedParentId
          : null,
      items: _parentItems,
      onChanged: (value) {
        setState(() {
          _selectedParentId = value;
        });
        widget.onChanged(value);
      },
      decoration: const InputDecoration(
        labelText: 'Select Parent',
        border: OutlineInputBorder(),
      ),
    );
  }
}
