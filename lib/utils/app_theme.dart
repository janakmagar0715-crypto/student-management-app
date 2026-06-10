import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1565C0);       // Deep Blue
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);
  static const Color accentColor = Color(0xFF00BCD4);        // Cyan accent
  static const Color goldAccent = Color(0xFFFFB300);         // Gold for highlights

  // Background Colors
  static const Color scaffoldBg = Color(0xFFF5F7FA);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color surfaceBg = Color(0xFFEEF2FF);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A2340);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);

  // Department Colors
  static const Map<String, Color> departmentColors = {
    'Computer Science': Color(0xFF3B82F6),
    'Information Technology': Color(0xFF8B5CF6),
    'Electronics': Color(0xFFEC4899),
    'Mechanical': Color(0xFFF59E0B),
    'Civil': Color(0xFF10B981),
    'Management': Color(0xFFEF4444),
    'Other': Color(0xFF6B7280),
  };

  static Color getDepartmentColor(String dept) {
    return departmentColors[dept] ?? const Color(0xFF6B7280);
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: cardBg,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: primaryDark,
      ),
    );
  }
}

class AppConstants {
  static const String appName = 'EduTrack';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'EduTrack is a comprehensive student management application designed to help educators and administrators efficiently manage student records. It features real-time search, department-based filtering, profile management, and detailed student views — all in a clean, modern interface.';

  static const String studentName = 'Your Name';
  static const String studentId = 'Your Student ID';
  static const String courseName = 'Mobile Application Development';
  static const String semester = 'Spring 2025';

  static const List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
    'Management',
    'Other',
  ];

  static const List<String> defaultAvatars = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
    'https://i.pravatar.cc/150?img=8',
  ];
}
