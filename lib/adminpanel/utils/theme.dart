import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get orangeTheme {
    const primaryOrange = Color(0xFFFF6F00); // Deep orange
    const lightOrange = Color(0xFFFFA040); // Accent orange

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Color(0xFFFFF8F1), // Soft background

      colorScheme: const ColorScheme.light(
        primary: primaryOrange,
        secondary: lightOrange,
        background: Color(0xFFFFF8F1),
        error: Colors.red,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.orangePrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryOrange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.orangeAccent),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          // backgroundColor: primaryOrange,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFFFFA040), // Soft orange divider
        thickness: 1.2,
        space: 20, // space above and below the divider
        indent: 16,
        endIndent: 16,
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: MaterialStateProperty.all(primaryOrange),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4E2600), // Dark burnt orange
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF4E2600),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF5C4033)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF5C4033)),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF5C4033),
        ),
      ),
      // fontFamily: 'Poppins', // or any custom font you've added
    );
  }
}
