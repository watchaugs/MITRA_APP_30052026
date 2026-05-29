// lib/theme.dart
// ════════════════════════════════════════════════════════════
// MITRA Student App — Design System
// Extracted 1:1 from MITRA_App_Design.html CSS :root variables
// ════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

// ── Brand Color Tokens (from HTML :root) ──────────────────────
abstract final class MC {
  // Brand
  static const saffron     = Color(0xFFFF6B35);
  static const saffronLt   = Color(0xFFFF8C5A);
  static const saffronDk   = Color(0xFFE85520);
  static const indigo       = Color(0xFF2D1B69);
  static const indigoMid    = Color(0xFF4A2F9C);
  static const indigoLt     = Color(0xFF7C5CDD);
  static const emerald      = Color(0xFF00C389);
  static const emeraldDk    = Color(0xFF009E6D);
  static const gold         = Color(0xFFFFB800);
  static const goldDk       = Color(0xFFE5A600);
  static const crimson      = Color(0xFFFF3B55);
  static const sky          = Color(0xFF0EA5E9);

  // Dark backgrounds (default dark theme)
  static const bgDeep       = Color(0xFF0A0612);
  static const bgCard       = Color(0xFF120C24);
  static const bgSurface    = Color(0xFF1C1232);
  static const bgInput      = Color(0xFF231846);

  // Light backgrounds (light theme)
  static const bgDeepLight    = Color(0xFFF5F0FF);
  static const bgCardLight    = Color(0xFFFFFFFF);
  static const bgSurfaceLight = Color(0xFFF0EBF8);

  // Text (dark theme)
  static const textPrimary    = Color(0xFFF5F0FF);
  static const textSecondary  = Color(0xFFA599CC);
  static const textMuted      = Color(0xFF6B5E8A);

  // Text (light theme)
  static const textPrimaryLt   = Color(0xFF1A0A3E);
  static const textSecondaryLt = Color(0xFF4A2F9C);
  static const textMutedLt     = Color(0xFF7C5CDD);

  // Border
  static const border       = Color(0x337C5CDD);   // rgba(124,92,221,0.2)
  static const borderLight  = Color(0x14FFFFFF);    // rgba(255,255,255,0.08)
}

// ── Gradients ─────────────────────────────────────────────────
abstract final class MG {
  static const saffron = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [MC.saffron, MC.gold],
  );
  static const indigo = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [MC.indigo, MC.indigoLt],
  );
  static const emerald = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [MC.emerald, MC.sky],
  );
  static const hero = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF1A0A3E), Color(0xFF2D1B69), Color(0xFF0F2A1A)],
    stops: [0.0, 0.4, 1.0],
  );
  static const cardDark = LinearGradient(
    begin: Alignment.topLeft, end: Alignment.bottomRight,
    colors: [Color(0xFF1C1232), Color(0xFF120C24)],
  );
}

// ── Typography ─────────────────────────────────────────────────
abstract final class MT {
  static TextStyle display(double size, {
    FontWeight weight = FontWeight.w800,
    Color color = MC.textPrimary,
  }) => TextStyle(
    fontFamily:  'Baloo2',
    fontSize:    size,
    fontWeight:  weight,
    color:       color,
    height:      1.2,
  );

  static TextStyle body(double size, {
    FontWeight weight = FontWeight.w400,
    Color color = MC.textPrimary,
  }) => TextStyle(
    fontFamily:  'Mukta',
    fontSize:    size,
    fontWeight:  weight,
    color:       color,
    height:      1.55,
  );

  static TextStyle mono(double size, {Color color = MC.textSecondary}) =>
      TextStyle(fontFamily: 'SpaceMono', fontSize: size, color: color);
}

// ── Spacing / Radius ──────────────────────────────────────────
abstract final class MR {
  static const xs   = 6.0;
  static const sm   = 10.0;
  static const md   = 16.0;
  static const lg   = 20.0;
  static const pill = 999.0;
}

// ── ThemeData builder ─────────────────────────────────────────
ThemeData buildMitraTheme({bool dark = true}) {
  final isDark = dark;

  final bg      = isDark ? MC.bgDeep    : MC.bgDeepLight;
  final card    = isDark ? MC.bgCard    : MC.bgCardLight;
  final surface = isDark ? MC.bgSurface : MC.bgSurfaceLight;
  final txtPri  = isDark ? MC.textPrimary   : MC.textPrimaryLt;
  final txtSec  = isDark ? MC.textSecondary : MC.textSecondaryLt;

  return ThemeData(
    useMaterial3:         true,
    brightness:           isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: bg,

    colorScheme: ColorScheme(
      brightness:   isDark ? Brightness.dark : Brightness.light,
      primary:      MC.saffron,
      onPrimary:    Colors.white,
      secondary:    MC.indigoLt,
      onSecondary:  Colors.white,
      tertiary:     MC.emerald,
      onTertiary:   Colors.white,
      surface:      card,
      onSurface:    txtPri,
      error:        MC.crimson,
      onError:      Colors.white,
    ),

    textTheme: TextTheme(
      displayLarge:  MT.display(32, color: txtPri),
      displayMedium: MT.display(26, color: txtPri),
      displaySmall:  MT.display(20, color: txtPri),
      headlineMedium: MT.display(18, weight: FontWeight.w700, color: txtPri),
      headlineSmall:  MT.display(16, weight: FontWeight.w700, color: txtPri),
      titleLarge:  MT.body(16, weight: FontWeight.w600, color: txtPri),
      titleMedium: MT.body(14, weight: FontWeight.w500, color: txtPri),
      bodyLarge:   MT.body(15, color: txtPri),
      bodyMedium:  MT.body(13, color: txtSec),
      bodySmall:   MT.body(12, color: txtSec),
      labelLarge:  MT.body(13, weight: FontWeight.w500, color: txtPri),
      labelSmall:  MT.body(11, color: txtSec),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor:     bg,
      surfaceTintColor:    Colors.transparent,
      elevation:           0,
      scrolledUnderElevation: 0,
      titleTextStyle: MT.display(17, weight: FontWeight.w700, color: txtPri),
      iconTheme: IconThemeData(color: txtSec),
    ),

    cardTheme: CardThemeData(
      color:        card,
      elevation:    0,
      surfaceTintColor: Colors.transparent,
      shape:        RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MR.md),
        side:         const BorderSide(color: MC.border),
      ),
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled:      true,
      fillColor:   surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MR.sm),
        borderSide: const BorderSide(color: MC.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MR.sm),
        borderSide: const BorderSide(color: MC.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MR.sm),
        borderSide: const BorderSide(color: MC.saffron, width: 1.5),
      ),
      hintStyle: MT.body(13, color: MC.textMuted),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: MC.saffron,
        foregroundColor: Colors.white,
        textStyle: MT.body(15, weight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MR.sm)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        elevation: 0,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: txtSec,
        side: const BorderSide(color: MC.border),
        textStyle: MT.body(14, weight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MR.sm)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:     card,
      selectedItemColor:   MC.saffron,
      unselectedItemColor: MC.textMuted,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      elevation: 0,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? MC.saffron : MC.textMuted),
      trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
              ? MC.saffron.withValues(alpha: 0.3)
              : surface),
    ),

    dividerTheme: const DividerThemeData(color: MC.border, thickness: 1, space: 1),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: card,
      contentTextStyle: MT.body(13, color: txtPri),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MR.sm)),
    ),
  );
}

// ── Dynamic Theme from AppConfig JSON ─────────────────────────
/// Merges Dashboard-provided hex colors into a ThemeData at runtime.
ThemeData buildDynamicTheme({
  required bool dark,
  String? primaryHex,
  String? secondaryHex,
}) {
  final base = buildMitraTheme(dark: dark);
  if (primaryHex == null) return base;

  final primary   = _hex(primaryHex) ?? MC.saffron;
  final secondary = (secondaryHex != null ? _hex(secondaryHex) : null) ?? MC.indigoLt;

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(primary: primary, secondary: secondary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: base.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStateProperty.all(primary),
      ),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      selectedItemColor: primary,
    ),
  );
}

Color? _hex(String hex) {
  final clean = hex.replaceAll('#', '');
  if (clean.length == 6) {
    return Color(int.parse('FF$clean', radix: 16));
  }
  return null;
}