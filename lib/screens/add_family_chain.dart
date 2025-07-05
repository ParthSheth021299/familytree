import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/screens/home_screen.dart';
import 'package:family_tree/screens/image_picker.dart';
import 'package:family_tree/service/google_sheet_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/family_member.dart';

class AddFamilyChainScreen extends StatefulWidget {
  const AddFamilyChainScreen({super.key});

  @override
  State<AddFamilyChainScreen> createState() => _AddFamilyChainScreenState();
}

class _AddFamilyChainScreenState extends State<AddFamilyChainScreen> {
  final _formKey = GlobalKey<FormState>();
  final GoogleSheetsService _service = GoogleSheetsService();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController memberName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController whatsapp = TextEditingController();
  final TextEditingController bloodGroup = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final TextEditingController spouseName = TextEditingController();
  final TextEditingController spouseEmail = TextEditingController();
  final TextEditingController spouseWhatsapp = TextEditingController();
  final TextEditingController spouseBloodGroup = TextEditingController();
  final TextEditingController spouseLocation = TextEditingController();
  final TextEditingController spouseDOBController = TextEditingController();

  DateTime? _selectedDOB;
  DateTime? spouseDOB;
  String uploadedImageUrl = '';
  String spouseImageUrl = '';
  String gender = 'Male';

  String isMarried = 'false';
  String isRoot = 'false';
  String hasChildren = 'false';

  FamilyMember? selectedParent;

  void clearFields() {
    memberName.clear();
    email.clear();
    location.clear();
    whatsapp.clear();
    bloodGroup.clear();
    _dobController.clear();
    uploadedImageUrl = '';
    selectedParent = null;
    isMarried = 'false';
    isRoot = 'false';
    hasChildren = 'false';
    gender = 'Male';
    spouseName.clear();
    spouseEmail.clear();
    spouseWhatsapp.clear();
    spouseBloodGroup.clear();
    spouseLocation.clear();
    spouseDOBController.clear();
    spouseImageUrl = '';
  }

  Future<void> _selectDOB(BuildContext context, bool isSpouse) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isSpouse) {
          spouseDOB = picked;
          spouseDOBController.text = DateFormat(
            'dd-MM-yyyy',
          ).format(picked.toLocal());
        } else {
          _selectedDOB = picked;
          _dobController.text = DateFormat(
            'dd-MM-yyyy',
          ).format(picked.toLocal());
        }
      });
    }
  }

  String generateUniqueId(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey()}';
  }

  Future<void> saveFamilyMember() async {
    if (!_formKey.currentState!.validate()) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    final parentId = selectedParent?.id ?? "";
    final houseRoot = isRoot == 'true'
        ? memberName.text.trim()
        : selectedParent?.houseRoot ?? "";
    final memberId = generateUniqueId("mem");

    final newMember = FamilyMember(
      id: memberId,
      parentId: parentId,
      name: memberName.text.trim(),
      houseRoot: houseRoot,
      gender: gender,
      bloodGroup: bloodGroup.text.trim(),
      whatsapp: whatsapp.text.trim(),
      maritalStatus: isMarried == 'true' ? "Married" : "Unmarried",
      spouseName: isMarried == 'true' ? spouseName.text.trim() : "",
      hasChildren: hasChildren,
      email: email.text.trim(),
      location: location.text.trim(),
      photoUrl: uploadedImageUrl,
      isRoot: isRoot,
      dob: _dobController.text,
      spousePhotoUrl: spouseImageUrl,
      spouseWhatsapp: spouseWhatsapp.text.trim(),
      spouseBloodGroup: spouseBloodGroup.text.trim(),
      spouseEmail: spouseEmail.text.trim(),
      spouseLocation: spouseLocation.text.trim(),
    );

    await _service.insertMember(newMember);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Family member saved")));

    clearFields();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomeScreen()),
      (route) => false,
    );
  }

  String? _required(String? val) =>
      (val == null || val.trim().isEmpty) ? 'Required' : null;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addFamilyMember),
      ),
      body: FutureBuilder<List<FamilyMember>>(
        future: _service.fetchFamilyData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final existing = snapshot.data!;

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<FamilyMember>(
                    value: existing.any((m) => m.id == selectedParent?.id)
                        ? existing.firstWhere((m) => m.id == selectedParent?.id)
                        : null,
                    items: existing.map((member) {
                      return DropdownMenuItem(
                        value: member,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: member.photoUrl.isNotEmpty
                                  ? NetworkImage(member.photoUrl)
                                  : null,
                              child: member.photoUrl.isEmpty
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(member.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (member) =>
                        setState(() => selectedParent = member),
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.selectParent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: memberName,
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.yourName,
                    ),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text(AppLocalizations.of(context)!.genderMale),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text(AppLocalizations.of(context)!.female),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: Text(AppLocalizations.of(context)!.other),
                      ),
                    ],
                    onChanged: (val) => setState(() => gender = val ?? 'Male'),
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.gender,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ImagePickerWidget(
                    onImageUploaded: (url) => uploadedImageUrl = url,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () => _selectDOB(context, false),
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.dob,
                    ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: whatsapp,
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.whatsapp,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: bloodGroup,
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.bloodGroup,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: email,
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: location,
                    decoration: _inputDecoration(
                      AppLocalizations.of(context)!.location,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.areYouMarried),
                    value: isMarried == 'true',
                    onChanged: (val) =>
                        setState(() => isMarried = val ? 'true' : 'false'),
                  ),
                  if (isMarried == 'true') ...[
                    const Divider(),
                    Text(
                      AppLocalizations.of(context)!.spouseDetails,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseName,
                      decoration: _inputDecoration("Spouse Name"),
                    ),
                    const SizedBox(height: 8),
                    ImagePickerWidget(
                      onImageUploaded: (url) => spouseImageUrl = url,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseDOBController,
                      readOnly: true,
                      onTap: () => _selectDOB(context, true),
                      decoration: _inputDecoration(
                        'Spouse DOB',
                      ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseEmail,
                      decoration: _inputDecoration("Spouse Email"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseWhatsapp,
                      decoration: _inputDecoration("Spouse WhatsApp"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseBloodGroup,
                      decoration: _inputDecoration("Spouse Blood Group"),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: spouseLocation,
                      decoration: _inputDecoration("Spouse Location"),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text("Does this person have children?"),
                    value: hasChildren == 'true',
                    onChanged: (val) =>
                        setState(() => hasChildren = val ? 'true' : 'false'),
                  ),
                  SwitchListTile(
                    title: const Text("Mark as Root of Family"),
                    value: isRoot == 'true',
                    onChanged: (val) =>
                        setState(() => isRoot = val ? 'true' : 'false'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: saveFamilyMember,
                    child: const Text("Save Member"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
