// import 'package:family_tree/providers/local_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LanguageSelector extends StatelessWidget {
//   const LanguageSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final localeProvider = Provider.of<LocaleProvider>(context);
//     final currentLocale = localeProvider.locale.languageCode;

//     return DropdownButton<String>(
//       value: currentLocale,
//       onChanged: (String? languageCode) {
//         if (languageCode != null) {
//           localeProvider.setLocale(Locale(languageCode));
//         }
//       },
//       icon: Icon(Icons.language),
//       items: const [
//         DropdownMenuItem(value: 'en', child: Text('English')),
//         DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
//         DropdownMenuItem(value: 'gu', child: Text('ગુજરાતી')),
//       ],
//     );
//   }
// }
import 'package:family_tree/providers/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  Future<String> _getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCode') ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return FutureBuilder<String>(
      future: _getSavedLocale(),
      builder: (context, snapshot) {
        final currentLocale = snapshot.data ?? 'en';

        return DropdownButton<String>(
          value: currentLocale,
          onChanged: (String? languageCode) async {
            if (languageCode != null) {
              localeProvider.setLocale(Locale(languageCode));

              // Save to SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('languageCode', languageCode);
            }
          },
          icon: const Icon(Icons.language),
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
            DropdownMenuItem(value: 'gu', child: Text('ગુજરાતી')),
          ],
        );
      },
    );
  }
}
