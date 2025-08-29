import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Modern & Vibrant
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  // New Modern Gradient Palettes
  static const List<Color> auroraGradient = [
    Color(0xFF667eea), // Soft Blue
    Color(0xFF764ba2), // Soft Purple
  ];

  static const List<Color> sunsetGradient = [
    Color(0xFFf093fb), // Soft Pink
    Color(0xFFf5576c), // Soft Red
  ];

  static const List<Color> oceanGradient = [
    Color(0xFF4facfe), // Bright Blue
    Color(0xFF00f2fe), // Cyan
  ];

  static const List<Color> forestGradient = [
    Color(0xFF43e97b), // Bright Green
    Color(0xFF38f9d7), // Teal
  ];

  static const List<Color> fireGradient = [
    Color(0xFFfa709a), // Hot Pink
    Color(0xFFfee140), // Bright Yellow
  ];

  static const List<Color> cosmicGradient = [
    Color(0xFFa8edea), // Light Teal
    Color(0xFFfed6e3), // Light Pink
  ];

  static const List<Color> midnightGradient = [
    Color(0xFF2c3e50), // Dark Blue
    Color(0xFF34495e), // Darker Blue
  ];

  static const List<Color> springGradient = [
    Color(0xFFffecd2), // Cream
    Color(0xFFfcb69f), // Peach
  ];

  static const List<Color> autumnGradient = [
    Color(0xFFff9a9e), // Soft Red
    Color(0xFFfecfef), // Light Pink
  ];

  static const List<Color> winterGradient = [
    Color(0xFFa8caba), // Sage
    Color(0xFF5d4e75), // Deep Purple
  ];

  // Error and Warning Gradients
  static const List<Color> errorGradient = [
    Color(0xFFEF4444), // Red
    Color(0xFFDC2626), // Darker Red
  ];

  static const List<Color> warningGradient = [
    Color(0xFFF59E0B), // Amber
    Color(0xFFD97706), // Darker Amber
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981), // Emerald
    Color(0xFF059669), // Darker Emerald
  ];

  // Neon Colors - More Subtle & Elegant
  static const Color neonPink = Color(0xFFE91E63);
  static const Color neonBlue = Color(0xFF2196F3);
  static const Color neonGreen = Color(0xFF4CAF50);
  static const Color neonYellow = Color(0xFFFFEB3B);
  static const Color neonPurple = Color(0xFF9C27B0);
  static const Color neonOrange = Color(0xFFFF9800);
  static const Color neonCyan = Color(0xFF00BCD4);
  static const Color neonLime = Color(0xFFCDDC39);

  // Additional Colors
  static const Color electricBlue = Color(0xFF00B4DB);
  static const Color hotPink = Color(0xFFFF69B4);
  static const Color limeGreen = Color(0xFF32CD32);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color teal = Color(0xFF009688);
  static const Color amber = Color(0xFFFFC107);

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.grey.shade800,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade800,
      ),
    );
  }
}
