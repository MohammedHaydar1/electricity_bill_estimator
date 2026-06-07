import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary     = Color(0xFF37474F); // blue-grey dark
  static const Color accent      = Color(0xFF78909C); // blue-grey medium
  static const Color background  = Color(0xFFF5F5F5); // near-white grey
  static const Color cardColor   = Colors.white;
  static const Color error       = Color(0xFFC62828);
  static const Color success     = Color(0xFF2E7D32);
  static const Color textDark    = Color(0xFF212121); // almost black
  static const Color textMuted   = Color(0xFF757575); // mid grey

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardColor,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error, width: 1.5),
          ),
          labelStyle: const TextStyle(color: textMuted),
          prefixIconColor: primary,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: primary,
          thumbColor: primary,
          inactiveTrackColor: Color(0xFFBDBDBD),
          overlayColor: Color(0x2937474F),
        ),
      );
}