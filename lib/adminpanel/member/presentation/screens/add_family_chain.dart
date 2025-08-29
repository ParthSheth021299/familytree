import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
import 'package:family_tree/adminpanel/language/presentation/screens/language_screen.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  final spouseLocationController = TextEditingController();
  final locationController = TextEditingController();

  String? mainRoot = 'Jai Hatkesh';

  String isMarried = 'false';
  String isInternalRoot = 'false';
  String isAlive = 'true';
  String? internalRootId;
  String? gender; // 'male' or 'female'

  final TextEditingController spouseBloodGroupController =
      TextEditingController();
  final TextEditingController spouseDobController = TextEditingController();
  final TextEditingController spousePhoneController = TextEditingController();
  final TextEditingController spouseEmailController = TextEditingController();

  String? spouseGender; // 'male' or 'female'

  List<DocumentSnapshot> internalRootOptions = [];
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  String? selectedBloodGroup;
  String? selctedSpouseBloodGroup;
  PhoneNumber number = PhoneNumber(isoCode: 'IN'); // Default India

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInternalRoots();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    bloodGroupController.dispose();
    dobController.dispose();
    spouseNameController.dispose();
    locationController.dispose();
    spouseLocationController.dispose();
    spouseEmailController.dispose();
    super.dispose();
  }

  Future<void> fetchInternalRoots() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query = await FirebaseFirestore.instance
        .collection('family_members')
        // .where('isRoot', isEqualTo: true)
        .where('createdBy', isEqualTo: uid) // 🔥 Only user-specific roots
        .get();

    setState(() => internalRootOptions = query.docs);
  }

  Future<void> saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final memberData = {
      // 'name': nameController.text.trim(),
      // 'phone': phoneController.text.trim(),
      // 'email': emailController.text.trim(),
      // 'bloodGroup': bloodGroupController.text.trim(),
      // 'dob': dobController.text.trim(),
      // 'spouseName': isMarried == 'true' ? spouseNameController.text.trim() : '',
      // 'isMarried': isMarried == 'true',
      // 'mainRoot': mainRoot,
      // 'createdBy': uid,
      // 'createdAt': FieldValue.serverTimestamp(),
      // 'isRoot': isInternalRoot == 'true',
      // 'parentId': isInternalRoot == 'true' ? null : internalRootId,
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'bloodGroup': selectedBloodGroup?.trim(),
      'dob': dobController.text.trim(),
      'gender': gender, // new field for main member
      'location': locationController.text.trim(),

      'isMarried': isMarried == 'true',
      'spouseName': isMarried == 'true' ? spouseNameController.text.trim() : '',
      'spouseGender': isMarried == 'true' ? spouseGender : '',
      'spouseDob': isMarried == 'true' ? spouseDobController.text.trim() : '',
      'spousePhone': isMarried == 'true'
          ? spousePhoneController.text.trim()
          : '',
      'spouseBloodGroup': isMarried == 'true'
          ? selctedSpouseBloodGroup?.trim()
          : '',
      'spouseLocation': isMarried == 'true'
          ? spouseLocationController.text.trim()
          : '',
      'spouseEmail': isMarried == 'true'
          ? spouseEmailController.text.trim()
          : '',

      'mainRoot': mainRoot,
      'createdBy': uid,
      'createdAt': FieldValue.serverTimestamp(),
      'isRoot': isInternalRoot == 'true',
      'parentId': isInternalRoot == 'true' ? null : internalRootId,
      // 'isAlive': isAlive,
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
    spouseNameController.clear();
    spouseDobController.clear();
    spousePhoneController.clear();
    selectedBloodGroup = null;
    selctedSpouseBloodGroup = null;
    mainRoot = null;
    locationController.clear();
    spouseLocationController.clear();
    spouseEmailController.clear();
    setState(() {});
  }

  Future<void> pickDOB(TextEditingController contorller) async {
    final theme = Theme.of(context);

    final picked = await showDatePicker(
      confirmText: "Select",
      cancelText: "Cancel",

      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    theme.colorScheme.primary, // OK/Cancel button color
              ),
            ),
            dialogBackgroundColor: theme.dialogBackgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      contorller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchInternalRoots();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addFamilyMember),
        automaticallyImplyLeading: false,

        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'language') {
                // Handle language change
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LanguageGridScreen()),
                );
              } else if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const GuestUserDashBoard()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'language',
                child: Row(
                  children: [
                    Icon(Icons.language, size: 20, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.languages),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AppColors.orangeDark),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Note Box
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.orangePrimary.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${AppLocalizations.of(context)!.noteTitle}\n',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.noteMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // DropdownButtonFormField<String>(
                //   decoration: InputDecoration(
                //     labelText: AppLocalizations.of(context)!.selectMainRoot,
                //   ),
                //   items: ['Dahibanagar', 'Kubernagar']
                //       .map(
                //         (name) =>
                //             DropdownMenuItem(value: name, child: Text(name)),
                //       )
                //       .toList(),
                //   onChanged: (val) async {
                //     setState(() {
                //       mainRoot = val;
                //       internalRootId = null;
                //     });
                //     await fetchInternalRoots();
                //   },
                //   validator: (val) => val == null ? 'Required' : null,
                // ),
                SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.name,
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber num) {
                    phoneController.text = num.phoneNumber.toString();
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DROPDOWN,
                  ),
                  initialValue: number,
                  textFieldController: TextEditingController(),
                  formatInput: false,

                  keyboardType: TextInputType.phone,
                  inputDecoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.phoneNumber,
                  ),
                  // inputFormatters: [
                  //   FilteringTextInputFormatter
                  //       .digitsOnly, // Only numbers allowed
                  // ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value:
                      selectedBloodGroup, // Define and manage this in your state
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.bloodGroup,
                    border: OutlineInputBorder(),
                  ),
                  items: bloodGroups.map((String group) {
                    return DropdownMenuItem<String>(
                      value: group,
                      child: Text(group),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedBloodGroup = newValue!;
                    });
                  },
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.gender,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: RadioListTile<String>(
                        title: Text(AppLocalizations.of(context)!.male),
                        value: 'male',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val),
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<String>(
                        title: Text(AppLocalizations.of(context)!.female),
                        value: 'female',
                        groupValue: gender,
                        onChanged: (val) => setState(() => gender = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: dobController,
                  readOnly: true,
                  onTap: () => pickDOB(dobController),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dob,
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: AppColors.orangePrimary,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.areYouMarried),

                  value: isMarried == 'true',
                  onChanged: (val) =>
                      setState(() => isMarried = val ? 'true' : 'false'),
                ),
                SizedBox(height: 20),
                // SwitchListTile(
                //   title: Text('Alive'),

                //   value: isAlive == 'true',
                //   onChanged: (val) =>
                //       setState(() => isAlive = val ? 'true' : 'false'),
                // ),
                // SizedBox(height: 20),
                if (isMarried == 'true') ...[
                  TextFormField(
                    controller: spouseNameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.spouseName,
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.spouseGender,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(AppLocalizations.of(context)!.male),
                          value: 'male',
                          groupValue: spouseGender,
                          onChanged: (val) =>
                              setState(() => spouseGender = val),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(AppLocalizations.of(context)!.female),
                          value: 'female',
                          groupValue: spouseGender,
                          onChanged: (val) =>
                              setState(() => spouseGender = val),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value:
                        selctedSpouseBloodGroup, // Define and manage this in your state
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.bloodGroup,
                      border: OutlineInputBorder(),
                    ),
                    items: bloodGroups.map((String group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selctedSpouseBloodGroup = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: spouseDobController,
                    readOnly: true,
                    onTap: () => pickDOB(spouseDobController),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.spouseDob,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(height: 20),
                  // TextFormField(
                  //   controller: spousePhoneController,
                  //   decoration: InputDecoration(
                  //     labelText: AppLocalizations.of(
                  //       context,
                  //     )!.spousePhoneNumber,
                  //   ),
                  //   keyboardType: TextInputType.phone,
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter
                  //         .digitsOnly, // Only numbers allowed
                  //   ],
                  // ),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber num) {
                      spousePhoneController.text = num.phoneNumber.toString();
                    },
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DROPDOWN,
                    ),
                    initialValue: number,
                    textFieldController: TextEditingController(),
                    formatInput: false,

                    keyboardType: TextInputType.phone,
                    inputDecoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.spousePhoneNumber,
                    ),
                    // inputFormatters: [
                    //   FilteringTextInputFormatter
                    //       .digitsOnly, // Only numbers allowed
                    // ],
                  ),
                  SizedBox(height: 20),
                ],
                SizedBox(height: 20),
                const Divider(),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.markAsInternalRoot),
                  value: isInternalRoot == 'true',
                  onChanged: (val) => setState(() {
                    isInternalRoot = val ? 'true' : 'false';
                    if (!val) internalRootId = null;
                  }),
                ),
                SizedBox(height: 20),
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
                    validator: (val) => val == null
                        ? AppLocalizations.of(context)!.selectRootPerson
                        : null,
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.save),
                    onPressed: saveMember,
                    label: Text(AppLocalizations.of(context)!.saveMember),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
