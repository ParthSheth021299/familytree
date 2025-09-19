import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TreeVisibilitySettingsScreen extends StatefulWidget {
  const TreeVisibilitySettingsScreen({super.key});

  @override
  State<TreeVisibilitySettingsScreen> createState() =>
      _TreeVisibilitySettingsScreenState();
}

class _TreeVisibilitySettingsScreenState
    extends State<TreeVisibilitySettingsScreen> {
  // Example local state (later replace with Firestore data)
  bool showPhotos = true;
  bool showDOB = false;
  bool showSpouse = true;
  bool showContact = false;
  bool showLocation = false;
  bool showAliveStatus = true;
  bool showEmail = false;
  bool showBloodGroup = false;
  bool loading = true;

  final _docRef = FirebaseFirestore.instance
      .collection("settings")
      .doc("treeVisibility");

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final snapshot = await _docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          showPhotos = data["showPhotos"] ?? true;
          showDOB = data["showDOB"] ?? true;
          showSpouse = data["showSpouse"] ?? true;
          showContact = data["showContact"] ?? true;
          showAliveStatus = data["showAliveStatus"] ?? true;
          showEmail = data["showEmail"] ?? true;
          showLocation = data["showLocation"] ?? true;
          showBloodGroup = data["showBloodGroup"] ?? true;
          loading = false;
        });
      } else {
        // Create default doc if not exists
        await _docRef.set({
          "showPhotos": showPhotos,
          "showDOB": showDOB,
          "showSpouse": showSpouse,
          "showContact": showContact,
          "showAliveStatus": showAliveStatus,
          "showLocation": showLocation,
          "showBloodGroup": showBloodGroup,
          "showEmail": showEmail,
        });
        setState(() => loading = false);
      }
    } catch (e) {
      debugPrint("⚠️ Error loading settings: $e");
      setState(() => loading = false);
    }
  }

  Future<void> saveSettings() async {
    try {
      await _docRef.set({
        "showPhotos": showPhotos,
        "showDOB": showDOB,
        "showSpouse": showSpouse,
        "showContact": showContact,
        "showAliveStatus": showAliveStatus,
        "showLocation": showLocation,
        "showBloodGroup": showBloodGroup,
        "showEmail": showEmail,
      });
      if (mounted) {
        showToast("Settings saved successfully!");
      }
    } catch (e) {
      if (mounted) {
        showToast("Error saving: $e", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.treeVisibilitySettings),
        // backgroundColor: Colors.green.shade700,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Colors.green.shade700,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            // TODO: save to Firestore
            saveSettings();
            // showToast("Settings saved successfully!");
          },
          icon: const Icon(Icons.save),
          label: Text(AppLocalizations.of(context)!.saveSettings),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            AppLocalizations.of(context)!.controlVisibleInfo,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // Personal Info Section
          _buildSectionTitle(AppLocalizations.of(context)!.personalInfo),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showPhotos),
            value: showPhotos,
            onChanged: (val) => setState(() => showPhotos = val),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showDOB),
            value: showDOB,
            onChanged: (val) => setState(() => showDOB = val),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showBloodGroup),
            value: showBloodGroup,
            onChanged: (val) => setState(() => showBloodGroup = val),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showLocation),
            value: showLocation,
            onChanged: (val) => setState(() => showLocation = val),
          ),
          const Divider(),

          // Relationship Section
          _buildSectionTitle(AppLocalizations.of(context)!.relationships),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showSpouse),
            value: showSpouse,
            onChanged: (val) => setState(() => showSpouse = val),
          ),
          const Divider(),

          // Contact Section
          _buildSectionTitle(AppLocalizations.of(context)!.contactInfo),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showContactDetails),
            value: showContact,
            onChanged: (val) => setState(() => showContact = val),
          ),

          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showEmail),
            value: showEmail,
            onChanged: (val) => setState(() => showEmail = val),
          ),
          const Divider(),
          // Alive Section
          _buildSectionTitle(AppLocalizations.of(context)!.status),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.showAliveDeadStatus),
            value: showAliveStatus,
            onChanged: (val) => setState(() => showAliveStatus = val),
          ),

          const SizedBox(height: 30),

          // Save Button
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
