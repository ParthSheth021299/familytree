import 'package:family_tree/adminpanel/auth/screens/login_screen.dart';
import 'package:family_tree/adminpanel/setting/presentation/widgets/control_panel.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:family_tree/adminpanel/language/presentation/screens/language_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  bool isComingFromAdmin;
  SettingScreen({super.key, required this.isComingFromAdmin});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var isLogged;

  isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogged = prefs.get("isAdminLoggedIn");
    });
  }

  @override
  void initState() {
    super.initState();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        // backgroundColor: Colors.white,
        // foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          Text(
            AppLocalizations.of(context)!.preferences,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.indigo),
              title: Text(AppLocalizations.of(context)!.languages),
              subtitle: Text(AppLocalizations.of(context)!.selectLanguage),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LanguageGridScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          if (widget.isComingFromAdmin == false) ...[
            Text(
              AppLocalizations.of(context)!.account,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.lock_open, color: Colors.deepOrange),
                title: Text(AppLocalizations.of(context)!.login),
                subtitle: Text(AppLocalizations.of(context)!.loginText),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),
          ],
          if (widget.isComingFromAdmin == true) ...[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(
                  Icons.control_point,
                  color: AppColors.orangePrimary,
                ),
                title: Text(AppLocalizations.of(context)!.controlPanel),
                subtitle: Text(AppLocalizations.of(context)!.chooseVisibleData),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TreeVisibilitySettingsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
