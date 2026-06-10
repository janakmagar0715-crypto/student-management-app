import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App info card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryDark, AppTheme.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.school_rounded, size: 48, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 16),
                const Text(AppConstants.appName,
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text('Version ${AppConstants.appVersion}',
                  style: TextStyle(color: Colors.white.withOpacity(0.7))),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    AppConstants.appDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Developer info
          _sectionTitle('Developer Information'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  _infoRow(Icons.person_rounded, 'Student Name', AppConstants.studentName, AppTheme.primaryColor),
                  const Divider(height: 1, indent: 52),
                  _infoRow(Icons.badge_rounded, 'Student ID', AppConstants.studentId, AppTheme.accentColor),
                  const Divider(height: 1, indent: 52),
                  _infoRow(Icons.book_rounded, 'Course', AppConstants.courseName, Colors.orange),
                  const Divider(height: 1, indent: 52),
                  _infoRow(Icons.calendar_month_rounded, 'Semester', AppConstants.semester, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Features
          _sectionTitle('Features Implemented'),
          const SizedBox(height: 12),
          ..._features.map((f) => _featureItem(f['icon'] as IconData, f['title'] as String, f['desc'] as String)),
          const SizedBox(height: 24),

          // Tech stack
          _sectionTitle('Technology Stack'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Flutter 3.x', 'Dart 3.x', 'Provider', 'SharedPreferences',
                  'CachedNetworkImage', 'UUID', 'Material Design 3',
                ].map((tech) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(tech, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryColor)),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text('Made with ❤️ using Flutter',
              style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.7), fontSize: 13)),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    ),
  );

  Widget _infoRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  static final List<Map<String, dynamic>> _features = [
    {'icon': Icons.auto_awesome_rounded, 'title': 'Animated Splash Screen', 'desc': 'Custom animated logo with progress indicator'},
    {'icon': Icons.people_rounded, 'title': 'Student Management', 'desc': 'Add, edit, view and delete student records'},
    {'icon': Icons.search_rounded, 'title': 'Real-time Search', 'desc': 'Instant search across name, ID, email and department'},
    {'icon': Icons.filter_alt_rounded, 'title': 'Department Filter', 'desc': 'Filter students by their department'},
    {'icon': Icons.sort_rounded, 'title': 'Multi-sort Options', 'desc': 'Sort by name, ID, department, date added'},
    {'icon': Icons.verified_rounded, 'title': 'Form Validation', 'desc': 'Email, phone, and required field validation'},
    {'icon': Icons.save_rounded, 'title': 'Local Persistence', 'desc': 'Data stored locally using SharedPreferences'},
    {'icon': Icons.bar_chart_rounded, 'title': 'Statistics Dashboard', 'desc': 'Department-wise student distribution stats'},
    {'icon': Icons.image_rounded, 'title': 'Profile Images', 'desc': 'Cached network images with fallback avatars'},
    {'icon': Icons.edit_rounded, 'title': 'Edit Student Records', 'desc': 'Inline edit support for existing students'},
  ];
}
