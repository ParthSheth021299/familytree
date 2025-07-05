import 'package:family_tree/providers/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale.languageCode;

    return DropdownButton<String>(
      value: currentLocale,
      onChanged: (String? languageCode) {
        if (languageCode != null) {
          localeProvider.setLocale(Locale(languageCode));
        }
      },
      icon: Icon(Icons.language),
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
        DropdownMenuItem(value: 'gu', child: Text('ગુજરાતી')),
      ],
    );
  }
}
