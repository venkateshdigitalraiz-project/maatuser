import 'package:flutter/material.dart';

class AppColors {
  // Mobility Brand Colors
  static const Color primary = Color(0xFF0F172A); // Obsidian Black
  static const Color primaryVariant = Color(0xFF1E293B);
  
  // Electric Yellow / Gold Accent
  static const Color accentYellow = Color(0xFFFFC000); 
  static const Color accentYellowDark = Color(0xFFE5A900);
  
  // Electric Sky Blue
  static const Color accentBlue = Color(0xFF00AFF5);
  static const Color accentBlueLight = Color(0xFFE0F4FE);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF9FAFB); // Light neutral
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F4F6);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF111827); // Gray 900
  static const Color textSecondary = Color(0xFF4B5563); // Gray 600
  static const Color textMuted = Color(0xFF9CA3AF); // Gray 400
  
  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocused = Color(0xFF111827);

  // Status
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successLight = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFFEF2F2);

  // Gradients
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000),
      Color(0xFF1E293B),
    ],
  );

  static const LinearGradient amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFC000),
      Color(0xFFFFA000),
    ],
  );
}
