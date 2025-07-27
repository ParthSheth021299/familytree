// import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
// import 'package:family_tree/providers/local_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class LanguageScreen extends StatelessWidget {
//   const LanguageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final localeProvider = Provider.of<LocaleProvider>(context);
//     final currentLocale = localeProvider.locale;

//     final languages = [
//       {'name': 'English', 'locale': const Locale('en')},
//       {'name': 'हिन्दी', 'locale': const Locale('hi')},
//       {'name': 'ગુજરાતી', 'locale': const Locale('gu')},
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Select Language'), centerTitle: true),
//       body: ListView.builder(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         itemCount: languages.length,
//         itemBuilder: (context, index) {
//           final lang = languages[index];
//           final locale = lang['locale'] as Locale;
//           final isSelected = locale.languageCode == currentLocale.languageCode;

//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             elevation: 4,
//             child: ListTile(
//               title: Text(
//                 lang['name'] as String,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                   color: isSelected ? Theme.of(context).primaryColor : null,
//                 ),
//               ),
//               trailing: isSelected
//                   ? const Icon(Icons.check_circle, color: Colors.green)
//                   : const Icon(Icons.language),
//               onTap: () {
//                 if (!isSelected) {
//                   localeProvider.setLocale(locale);
//                 }

//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const GuestUserDashBoard(),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/providers/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// update this path as needed

class LanguageGridScreen extends StatelessWidget {
  LanguageGridScreen({super.key});

  // Static list of languages with initials, image, and Locale
  final List<Map<String, dynamic>> languages = [
    {
      'code': 'EN',
      'image': 'assets/images/en.png',
      'locale': const Locale('en'),
    },
    {
      'code': 'HI',
      'image': 'assets/images/hi.jpg',
      'locale': const Locale('hi'),
    },
    {
      'code': 'GUJ',
      'image': 'assets/images/gu.png',
      'locale': const Locale('gu'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chooseLanguage)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: languages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final lang = languages[index];
            final locale = lang['locale'] as Locale;
            final isSelected =
                locale.languageCode == currentLocale.languageCode;

            return GestureDetector(
              onTap: () {
                localeProvider.setLocale(locale);
              },
              child: Stack(
                children: [
                  // Background image with highlight if selected
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.orangeDark
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(lang['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Initials overlay text
                  Center(
                    child: Text(
                      lang['code'],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black87,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
