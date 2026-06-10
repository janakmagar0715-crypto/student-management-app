import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/app_theme.dart';
import 'add_student_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (_, provider, __) {
        final student = provider.getById(studentId);
        if (student == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student Details')),
            body: const Center(child: Text('Student not found')),
          );
        }

        final deptColor = AppTheme.getDepartmentColor(student.department);

        return Scaffold(
          backgroundColor: AppTheme.scaffoldBg,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primaryDark, AppTheme.primaryColor],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Hero(
                          tag: 'avatar_${student.id}',
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15),
                              ],
                            ),
                            child: ClipOval(
                              child: student.profilePictureUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: student.profilePictureUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => Container(
                                      color: deptColor.withOpacity(0.3),
                                      child: const Icon(Icons.person, color: Colors.white, size: 50),
                                    ),
                                    errorWidget: (_, __, ___) => Container(
                                      color: deptColor,
                                      child: const Icon(Icons.person, color: Colors.white, size: 50),
                                    ),
                                  )
                                : Container(
                                    color: deptColor,
                                    child: const Icon(Icons.person, color: Colors.white, size: 50),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(student.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: deptColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: deptColor.withOpacity(0.5)),
                          ),
                          child: Text(student.department, style: TextStyle(color: deptColor.withOpacity(1.5), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddStudentScreen(editStudent: student)),
                    ),
                    tooltip: 'Edit Student',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    onPressed: () => _confirmDelete(context, provider, student.name),
                    tooltip: 'Delete Student',
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoCard([
                        _infoRow(Icons.badge_outlined, 'Student ID', student.studentId),
                        const Divider(height: 1),
                        _infoRow(Icons.email_outlined, 'Email', student.email),
                        const Divider(height: 1),
                        _infoRow(Icons.phone_outlined, 'Phone', student.phone),
                        const Divider(height: 1),
                        _infoRow(Icons.business_outlined, 'Department', student.department),
                        const Divider(height: 1),
                        _infoRow(Icons.calendar_today_outlined, 'Registered', _formatDate(student.createdAt)),
                      ]),

                      if (student.notes != null && student.notes!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _sectionTitle('Notes'),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber[200]!),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.notes, color: Colors.amber[700], size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(student.notes!, style: TextStyle(color: Colors.amber[900])),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      _sectionTitle('Profile Picture URL'),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link, color: AppTheme.primaryColor, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                student.profilePictureUrl.isEmpty ? 'No URL provided' : student.profilePictureUrl,
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
  );

  Widget _infoCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(children: children),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
    '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _confirmDelete(BuildContext context, StudentProvider provider, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Delete Student', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        content: Text('Are you sure you want to delete $name?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteStudent(studentId);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
