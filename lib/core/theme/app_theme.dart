import 'package:flutter/material.dart';

class AppTheme {
  static const Color teal = Color(0xFF008080);
  static const Color orange = Color(0xFFFF9800);

  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      primaryColor: teal,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.teal,
        accentColor: orange,
      ).copyWith(secondary: orange),
      appBarTheme: const AppBarTheme(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: orange,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: teal),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: teal,
      colorScheme: ColorScheme.dark(primary: teal, secondary: orange),
      appBarTheme: const AppBarTheme(backgroundColor: teal, elevation: 0),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: orange,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: orange,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static Color? get tealPrimary => null;
}
