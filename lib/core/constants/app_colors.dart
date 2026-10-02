import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Colors (Slate & Indigo Palette)
  static const Color background = Color(0xff0f172a); // Slate 900
  static const Color surface = Color(0xff1e293b);    // Slate 800
  static const Color surfaceLight = Color(0xff334155); // Slate 700
  static const Color cardBg = Color(0xff1e293b);

  // Brand / Accents
  static const Color primary = Color(0xff6366f1);   // Indigo 500
  static const Color primaryLight = Color(0xff818cf8); // Indigo 400
  static const Color primaryDark = Color(0xff4f46e5);  // Indigo 600
  static const Color secondary = Color(0xff0ea5e9); // Sky 500
  static const Color accent = Color(0xff10b981);    // Emerald 500

  // Text Colors
  static const Color textPrimary = Color(0xfff8fafc);   // Slate 50
  static const Color textSecondary = Color(0xff94a3b8); // Slate 400
  static const Color textMuted = Color(0xff64748b);     // Slate 500

  // System Colors
  static const Color error = Color(0xffef4444);      // Red 500
  static const Color success = Color(0xff10b981);    // Emerald 500
  static const Color warning = Color(0xfff59e0b);    // Amber 500
  static const Color border = Color(0xff334155);     // Slate 700

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xff1e293b), Color(0xff0f172a)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
