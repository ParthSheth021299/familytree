import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:family_tree/l10n/app_localizations.dart';

// conditional import
import 'link_helper_mobile.dart' if (dart.library.html) 'link_helper_web.dart';

class DriveDownloadLink extends StatelessWidget {
  const DriveDownloadLink({super.key});

  final String driveUrl =
      "https://drive.google.com/file/d/1bVWY23Nn5nn8uGtC6G8_LvctOU4u1ydv/view?usp=drive_link";

  Future<void> _openLink() async {
    final uri = Uri.parse(driveUrl);

    if (kIsWeb) {
      // Web: open in new tab
      openWebLink(driveUrl);
    } else {
      // Mobile: use url_launcher
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $uri');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openLink,
      child: Text(
        AppLocalizations.of(context)!.download,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
