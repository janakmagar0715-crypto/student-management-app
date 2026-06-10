import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/app_theme.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? editStudent;  // Pass student for edit mode

  const AddStudentScreen({super.key, this.editStudent});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _urlCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _selectedDept = AppConstants.departments.first;
  bool _isSubmitting = false;

  bool get isEditMode => widget.editStudent != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final s = widget.editStudent!;
      _nameCtrl.text = s.name;
      _idCtrl.text = s.studentId;
      _emailCtrl.text = s.email;
      _phoneCtrl.text = s.phone;
      _urlCtrl.text = s.profilePictureUrl;
      _notesCtrl.text = s.notes ?? '';
      _selectedDept = s.department;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _urlCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 400));

    final provider = context.read<StudentProvider>();

    if (isEditMode) {
      final updated = widget.editStudent!.copyWith(
        name: _nameCtrl.text.trim(),
        studentId: _idCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        department: _selectedDept,
        profilePictureUrl: _urlCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
      );
      await provider.updateStudent(updated);
    } else {
      final student = Student(
        id: const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        studentId: _idCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        department: _selectedDept,
        profilePictureUrl: _urlCtrl.text.trim().isEmpty
          ? AppConstants.defaultAvatars[DateTime.now().second % AppConstants.defaultAvatars.length]
          : _urlCtrl.text.trim(),
        createdAt: DateTime.now(),
        notes: _notesCtrl.text.trim(),
      );
      await provider.addStudent(student);
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode ? 'Student updated successfully!' : 'Student added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _reset() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Form'),
        content: const Text('Clear all entered data?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.reset();
              _nameCtrl.clear(); _idCtrl.clear(); _emailCtrl.clear();
              _phoneCtrl.clear(); _urlCtrl.clear(); _notesCtrl.clear();
              setState(() => _selectedDept = AppConstants.departments.first);
              Navigator.pop(ctx);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Student' : 'Add New Student'),
        actions: [
          if (!isEditMode)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _reset, tooltip: 'Reset'),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_add_rounded, color: Colors.white, size: 36),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isEditMode ? 'Edit Student Record' : 'New Student Registration',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      Text('All fields are mandatory',
                        style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            _sectionLabel('Personal Information'),
            const SizedBox(height: 12),
            _buildField(
              controller: _nameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline,
              validator: (v) => v == null || v.trim().length < 2 ? 'Please enter a valid full name' : null,
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _idCtrl,
              label: 'Student ID',
              icon: Icons.badge_outlined,
              hint: 'e.g. CS-001',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Student ID is required';
                // Check for duplicates only when adding
                if (!isEditMode) {
                  final provider = context.read<StudentProvider>();
                  final exists = provider.allStudents.any((s) => s.studentId == v.trim());
                  if (exists) return 'Student ID already exists';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _sectionLabel('Contact Details'),
            const SizedBox(height: 12),
            _buildField(
              controller: _emailCtrl,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!regex.hasMatch(v.trim())) return 'Please enter a valid email address';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _phoneCtrl,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              hint: 'e.g. 9841234567',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone number is required';
                final digits = v.replaceAll(RegExp(r'\D'), '');
                if (digits.length < 10) return 'Phone number must be at least 10 digits';
                return null;
              },
            ),
            const SizedBox(height: 24),

            _sectionLabel('Academic Details'),
            const SizedBox(height: 12),
            // Department Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDept,
              decoration: InputDecoration(
                labelText: 'Department',
                prefixIcon: const Icon(Icons.business_outlined),
                filled: true,
                fillColor: AppTheme.surfaceBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
              items: AppConstants.departments.map((dept) {
                return DropdownMenuItem(
                  value: dept,
                  child: Row(
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(
                          color: AppTheme.getDepartmentColor(dept),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(dept),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => _selectedDept = val!),
            ),
            const SizedBox(height: 24),

            _sectionLabel('Profile Picture'),
            const SizedBox(height: 12),
            _buildField(
              controller: _urlCtrl,
              label: 'Profile Picture URL',
              icon: Icons.image_outlined,
              hint: 'https://... (optional)',
              validator: (v) {
                if (v == null || v.trim().isEmpty) return null;
                if (!v.trim().startsWith('http')) return 'Please enter a valid URL (starts with http)';
                return null;
              },
            ),
            if (_urlCtrl.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _urlCtrl.text,
                    height: 100, width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            const SizedBox(height: 24),

            _sectionLabel('Additional Notes (Optional)'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional information about the student...',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 42),
                  child: Icon(Icons.notes_outlined),
                ),
                filled: true,
                fillColor: AppTheme.surfaceBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    icon: _isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Icon(isEditMode ? Icons.save : Icons.person_add),
                    label: Text(_isSubmitting ? 'Saving...' : (isEditMode ? 'Save Changes' : 'Add Student')),
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: validator,
      onChanged: label.contains('URL') ? (_) => setState(() {}) : null,
    );
  }
}
