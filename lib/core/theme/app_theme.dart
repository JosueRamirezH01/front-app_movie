import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── COLORS ──────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceVariant = Color(0xFF1A1A26);
  static const Color primary = Color(0xFFE50914);       // Netflix red
  static const Color primaryDark = Color(0xFFB20710);
  static const Color accent = Color(0xFFFFD700);        // Gold - Peruvian touch
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textMuted = Color(0xFF616161);
  static const Color cardBg = Color(0xFF1E1E2E);
  static const Color divider = Color(0xFF2A2A3A);
  static const Color success = Color(0xFF4CAF50);
  static const Color overlay = Color(0x80000000);

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: surface,
      onPrimary: textPrimary,
      onSecondary: background,
      onSurface: textPrimary,
      error: Color(0xFFCF6679),
    ),
    textTheme: GoogleFonts.outfitTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary, fontSize: 48, fontWeight: FontWeight.w800,
          letterSpacing: -2, height: 1.1,
        ),
        displayMedium: TextStyle(
          color: textPrimary, fontSize: 36, fontWeight: FontWeight.w700,
          letterSpacing: -1.5, height: 1.15,
        ),
        displaySmall: TextStyle(
          color: textPrimary, fontSize: 28, fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          color: textPrimary, fontSize: 24, fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: textSecondary, fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textMuted, fontSize: 12),
        labelLarge: TextStyle(
          color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: textPrimary,
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: textPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: textSecondary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.outfit(
          fontSize: 15, fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      hintStyle: const TextStyle(color: textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: divider, thickness: 1, space: 0,
    ),
    iconTheme: const IconThemeData(color: textSecondary, size: 22),
    chipTheme: ChipThemeData(
      backgroundColor: surfaceVariant,
      labelStyle: GoogleFonts.outfit(
        color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

// ─── SPACING ───────────────────────────────────────────────────────────────────
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

// ─── DURATIONS ─────────────────────────────────────────────────────────────────
class AppDuration {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 600);
}