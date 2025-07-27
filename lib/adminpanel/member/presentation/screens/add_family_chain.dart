import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddFamilyChainScreen extends StatefulWidget {
  const AddFamilyChainScreen({super.key});

  @override
  State<AddFamilyChainScreen> createState() => _AddFamilyChainScreenState();
}

class _AddFamilyChainScreenState extends State<AddFamilyChainScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final dobController = TextEditingController();
  final spouseNameController = TextEditingController();

  String? mainRoot;
  String isMarried = 'false';
  String isInternalRoot = 'false';
  String? internalRootId;

  List<DocumentSnapshot> internalRootOptions = [];

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bloodGroupController.dispose();
    dobController.dispose();
    spouseNameController.dispose();
    super.dispose();
  }

  Future<void> fetchInternalRoots() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query = await FirebaseFirestore.instance
        .collection('family_members')
        .where('isRoot', isEqualTo: true)
        .where('createdBy', isEqualTo: uid) // 🔥 Only user-specific roots
        .get();

    setState(() => internalRootOptions = query.docs);
  }

  Future<void> saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final memberData = {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'bloodGroup': bloodGroupController.text.trim(),
      'dob': dobController.text.trim(),
      'spouseName': isMarried == 'true' ? spouseNameController.text.trim() : '',
      'isMarried': isMarried == 'true',
      'mainRoot': mainRoot,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'isRoot': isInternalRoot == 'true',
      'parentId': isInternalRoot == 'true' ? null : internalRootId,
    };

    await FirebaseFirestore.instance
        .collection('family_members')
        .add(memberData);

    showToast(AppLocalizations.of(context)!.familyMemberAdded);

    clearForm();
  }

  void clearForm() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    bloodGroupController.clear();
    dobController.clear();
    spouseNameController.clear();
    mainRoot = null;
    isMarried = 'false';
    isInternalRoot = 'false';
    internalRootId = null;
    internalRootOptions = [];
    setState(() {});
  }

  Future<void> pickDOB() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addFamilyMember),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.selectMainRoot,
                ),
                items: ['Dahibanagar', 'Kubernagar']
                    .map(
                      (name) =>
                          DropdownMenuItem(value: name, child: Text(name)),
                    )
                    .toList(),
                onChanged: (val) async {
                  setState(() {
                    mainRoot = val;
                    internalRootId = null;
                  });
                  await fetchInternalRoots();
                },
                validator: (val) => val == null ? 'Required' : null,
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                ),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: bloodGroupController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.bloodGroup,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              TextFormField(
                controller: dobController,
                readOnly: true,
                onTap: pickDOB,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.dob,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.areYouMarried),
                value: isMarried == 'true',
                onChanged: (val) =>
                    setState(() => isMarried = val ? 'true' : 'false'),
              ),
              if (isMarried == 'true')
                TextFormField(
                  controller: spouseNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.spouseName,
                  ),
                ),
              const Divider(),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.markAsInternalRoot),
                value: isInternalRoot == 'true',
                onChanged: (val) => setState(() {
                  isInternalRoot = val ? 'true' : 'false';
                  if (!val) internalRootId = null;
                }),
              ),
              if (isInternalRoot == 'false' && internalRootOptions.isNotEmpty)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(
                      context,
                    )!.selectFamilyRootPerson,
                  ),
                  items: internalRootOptions.map((doc) {
                    final name = doc['name'] ?? 'Unnamed';
                    return DropdownMenuItem(value: doc.id, child: Text(name));
                  }).toList(),
                  onChanged: (val) => setState(() => internalRootId = val),
                  validator: (val) => val == null ? 'Select root person' : null,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveMember,
                child: Text(AppLocalizations.of(context)!.saveMember),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
