import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- Colors ---
  static const primaryColor = Color(0xFF6C63FF);
  static const secondaryColor = Color(0xFF03DAC6);

  // Light Colors
  static const lightBg = Color(0xFFF8F9FA);
  static const lightSurface = Colors.white;
  static const lightText = Color(0xFF1E1E2C);

  // Dark Colors
  static const darkBg = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkText = Color(0xFFE0E0E0);

  static TextTheme _buildTextTheme(TextTheme base, Color color) {
    return GoogleFonts.cairoTextTheme(base).copyWith(
      // العناوين الكبيرة
      headlineLarge: GoogleFonts.cairo(
        fontSize: 30.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      // العناوين الفرعية
      headlineMedium: GoogleFonts.cairo(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      // النصوص العادية
      bodyLarge: GoogleFonts.cairo(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyMedium: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.normal,
        color: color.withValues(alpha: 0.8),
      ),
    );
  }

  // --- Light Theme ---
  static ThemeData get light {
    return ThemeData(
      textTheme: _buildTextTheme(
        ThemeData.light().textTheme,
        const Color(0xFF1E1E2C),
      ),
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBg,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
      ),
      // textTheme: GoogleFonts.cairoTextTheme(
      //   ThemeData.light().textTheme,
      // ).apply(bodyColor: lightText, displayColor: lightText),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightText),
        titleTextStyle: TextStyle(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- Dark Theme ---
  static ThemeData get dark {
    return ThemeData(
      textTheme: _buildTextTheme(
        ThemeData.dark().textTheme,
        const Color(0xFFE0E0E0),
      ),
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
      ),
      // textTheme: GoogleFonts.cairoTextTheme(
      //   ThemeData.dark().textTheme,
      // ).apply(bodyColor: darkText, displayColor: darkText),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkText),
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
