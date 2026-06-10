import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StatsBar extends StatelessWidget {
  final int total;
  final int departments;
  final int filtered;

  const StatsBar({
    super.key,
    required this.total,
    required this.departments,
    required this.filtered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _statItem('Total', '$total', Icons.people_rounded),
          _divider(),
          _statItem('Departments', '$departments', Icons.business_rounded),
          _divider(),
          _statItem('Showing', '$filtered', Icons.visibility_rounded),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 40,
    color: Colors.white24,
  );
}
