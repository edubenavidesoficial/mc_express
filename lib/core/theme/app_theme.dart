import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const Color black = Color(0xFF090909);
  static const Color charcoal = Color(0xFF171717);
  static const Color yellow = Color(0xFFFFD523);
  static const Color amber = Color(0xFFFFA800);
  static const Color softWhite = Color(0xFFF8F8F2);
  static const Color mutedText = Color(0xFFB8B8B8);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: black,
      colorScheme: ColorScheme.fromSeed(
        seedColor: yellow,
        brightness: Brightness.dark,
        primary: yellow,
        surface: charcoal,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: softWhite,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.05,
        ),
        titleLarge: TextStyle(
          color: softWhite,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(color: mutedText, fontSize: 16, height: 1.45),
        bodyMedium: TextStyle(color: mutedText, fontSize: 14, height: 1.35),
      ),
    );
  }
}
