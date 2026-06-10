import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/app_theme.dart';
import 'package:provider/provider.dart';
import '../screens/student_detail_screen.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final int index;

  const StudentCard({super.key, required this.student, required this.index});

  @override
  Widget build(BuildContext context) {
    final deptColor = AppTheme.getDepartmentColor(student.department);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentDetailScreen(studentId: student.id)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Hero(
                  tag: 'avatar_${student.id}',
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: deptColor.withOpacity(0.3), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: student.profilePictureUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: student.profilePictureUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: deptColor.withOpacity(0.1),
                              child: Icon(Icons.person, color: deptColor),
                            ),
                            errorWidget: (_, __, ___) => Container(
                              color: deptColor.withOpacity(0.1),
                              child: Icon(Icons.person, color: deptColor),
                            ),
                          )
                        : Container(
                            color: deptColor.withOpacity(0.1),
                            child: Icon(Icons.person, color: deptColor, size: 30),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.studentId,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: deptColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          student.department,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: deptColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StudentDetailScreen(studentId: student.id)),
                      ),
                      tooltip: 'View Details',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _confirmDelete(context),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
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
        content: Text('Are you sure you want to delete ${student.name}? This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<StudentProvider>().deleteStudent(student.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${student.name} deleted'),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'OK',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
