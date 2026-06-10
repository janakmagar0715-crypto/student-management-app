import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/student_card.dart';
import '../widgets/stats_card.dart';
import 'add_student_screen.dart';
import 'about_screen.dart';
// AppConstants is re-exported from app_theme.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSortDialog() {
    final provider = context.read<StudentProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sort Students', style: TextStyle(fontWeight: FontWeight.w600)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sortTile(ctx, 'Name (A → Z)', SortOption.nameAsc, Icons.sort_by_alpha, provider),
            _sortTile(ctx, 'Name (Z → A)', SortOption.nameDesc, Icons.sort_by_alpha, provider),
            _sortTile(ctx, 'Student ID', SortOption.idAsc, Icons.tag, provider),
            _sortTile(ctx, 'Department', SortOption.department, Icons.business, provider),
            _sortTile(ctx, 'Newest First', SortOption.newest, Icons.fiber_new, provider),
            _sortTile(ctx, 'Oldest First', SortOption.oldest, Icons.history, provider),
          ],
        ),
      ),
    );
  }

  Widget _sortTile(BuildContext ctx, String label, SortOption opt, IconData icon, StudentProvider provider) {
    final selected = provider.sortOption == opt;
    return ListTile(
      leading: Icon(icon, color: selected ? AppTheme.primaryColor : AppTheme.textSecondary),
      title: Text(label),
      trailing: selected ? const Icon(Icons.check, color: AppTheme.primaryColor) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: selected ? AppTheme.surfaceBg : null,
      onTap: () {
        provider.setSortOption(opt);
        Navigator.pop(ctx);
      },
    );
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Clear All Students', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: const Text('This will permanently delete all student records. This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<StudentProvider>().clearAll();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All students cleared'), backgroundColor: Colors.red),
              );
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    final provider = context.read<StudentProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter by Department',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: () {
                      provider.setFilterDepartment('All');
                      Navigator.pop(ctx);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', ...AppConstants.departments].map((dept) {
                  final selected = provider.filterDepartment == dept;
                  final color = dept == 'All'
                    ? AppTheme.primaryColor
                    : AppTheme.getDepartmentColor(dept);
                  return FilterChip(
                    label: Text(dept),
                    selected: selected,
                    selectedColor: color.withOpacity(0.2),
                    checkmarkColor: color,
                    labelStyle: TextStyle(
                      color: selected ? color : AppTheme.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    onSelected: (_) {
                      provider.setFilterDepartment(dept);
                      setS(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search students...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                border: InputBorder.none,
                filled: false,
              ),
              onChanged: (val) => context.read<StudentProvider>().setSearchQuery(val),
            )
          : const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() { _isSearching = !_isSearching; });
              if (!_isSearching) {
                _searchController.clear();
                context.read<StudentProvider>().setSearchQuery('');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort') _showSortDialog();
              else if (value == 'clear') _showClearConfirmation();
              else if (value == 'about') Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'sort', child: Row(children: [Icon(Icons.sort), SizedBox(width: 8), Text('Sort Students')])),
              const PopupMenuItem(value: 'clear', child: Row(children: [Icon(Icons.clear_all, color: Colors.red), SizedBox(width: 8), Text('Clear Student List', style: TextStyle(color: Colors.red))])),
              const PopupMenuItem(value: 'about', child: Row(children: [Icon(Icons.info_outline), SizedBox(width: 8), Text('About App')])),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen())),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
      body: Column(
        children: [
          // Stats bar
          Consumer<StudentProvider>(
            builder: (_, provider, __) => StatsBar(
              total: provider.allStudents.length,
              departments: provider.departmentStats.length,
              filtered: provider.filteredStudents.length,
            ),
          ),
          // Active filter chip
          Consumer<StudentProvider>(
            builder: (_, provider, __) {
              if (provider.filterDepartment == 'All') return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Chip(
                      label: Text(provider.filterDepartment),
                      backgroundColor: AppTheme.getDepartmentColor(provider.filterDepartment).withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: AppTheme.getDepartmentColor(provider.filterDepartment),
                        fontWeight: FontWeight.w600,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => provider.setFilterDepartment('All'),
                    ),
                  ],
                ),
              );
            },
          ),
          // Student list
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (_, provider, __) {
                final students = provider.filteredStudents;
                if (students.isEmpty) {
                  return _buildEmptyState(provider);
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: students.length,
                  itemBuilder: (ctx, i) => StudentCard(
                    student: students[i],
                    index: i,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(StudentProvider provider) {
    final isFiltered = provider.searchQuery.isNotEmpty || provider.filterDepartment != 'All';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered ? Icons.search_off : Icons.school_outlined,
            size: 80,
            color: AppTheme.textSecondary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No students match your search' : 'No Students Yet',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered ? 'Try different keywords or filters' : 'Tap the + button to add your first student',
            style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.7)),
          ),
          if (isFiltered) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                provider.setSearchQuery('');
                provider.setFilterDepartment('All');
                _searchController.clear();
                setState(() { _isSearching = false; });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryDark, Color(0xFF1A3A6B)],
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.school_rounded, size: 36, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 12),
                  const Text('EduTrack', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                  Text('Student Management', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ),
            _drawerItem(Icons.home_rounded, 'Home', () { Navigator.pop(context); }),
            _drawerItem(Icons.person_add_rounded, 'Add Student', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddStudentScreen()));
            }),
            _drawerItem(Icons.people_rounded, 'Student List', () { Navigator.pop(context); }),
            _drawerItem(Icons.bar_chart_rounded, 'Statistics', () {
              Navigator.pop(context);
              _showStatsDialog();
            }),
            _drawerItem(Icons.info_rounded, 'About', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
            }),
            const Spacer(),
            const Divider(color: Colors.white24),
            _drawerItem(Icons.exit_to_app_rounded, 'Exit', () {
              Navigator.pop(context);
              _showExitDialog();
            }, isDestructive: true),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red[300]! : Colors.white;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit EduTrack?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() {
    final provider = context.read<StudentProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Department Statistics', style: TextStyle(fontWeight: FontWeight.w600)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Students: ${provider.allStudents.length}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryColor)),
              const SizedBox(height: 16),
              ...provider.departmentStats.entries.map((e) {
                final pct = provider.allStudents.isEmpty ? 0.0 : e.value / provider.allStudents.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                          Text('${e.value} (${(pct * 100).toStringAsFixed(0)}%)'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: pct,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(AppTheme.getDepartmentColor(e.key)),
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
