import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/student.dart';

enum SortOption { nameAsc, nameDesc, idAsc, department, newest, oldest }

class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [];
  String _searchQuery = '';
  String _filterDepartment = 'All';
  SortOption _sortOption = SortOption.newest;

  List<Student> get allStudents => _students;

  List<Student> get filteredStudents {
    List<Student> result = List.from(_students);

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      result = result.where((s) =>
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.studentId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.department.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.email.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Filter by department
    if (_filterDepartment != 'All') {
      result = result.where((s) => s.department == _filterDepartment).toList();
    }

    // Sort
    switch (_sortOption) {
      case SortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        result.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.idAsc:
        result.sort((a, b) => a.studentId.compareTo(b.studentId));
        break;
      case SortOption.department:
        result.sort((a, b) => a.department.compareTo(b.department));
        break;
      case SortOption.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return result;
  }

  String get searchQuery => _searchQuery;
  String get filterDepartment => _filterDepartment;
  SortOption get sortOption => _sortOption;

  Map<String, int> get departmentStats {
    final Map<String, int> stats = {};
    for (final s in _students) {
      stats[s.department] = (stats[s.department] ?? 0) + 1;
    }
    return stats;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterDepartment(String dept) {
    _filterDepartment = dept;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    _students.add(student);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> updateStudent(Student updated) async {
    final idx = _students.indexWhere((s) => s.id == updated.id);
    if (idx != -1) {
      _students[idx] = updated;
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> deleteStudent(String id) async {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> clearAll() async {
    _students.clear();
    notifyListeners();
    await _saveToPrefs();
  }

  Student? getById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('students');
    if (data != null) {
      final List<dynamic> list = json.decode(data);
      _students.clear();
      _students.addAll(list.map((e) => Student.fromMap(e)).toList());
      notifyListeners();
    } else {
      // Load sample data on first run
      await _loadSampleData();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_students.map((s) => s.toMap()).toList());
    await prefs.setString('students', data);
  }

  Future<void> _loadSampleData() async {
    const uuid = Uuid();
    final samples = [
      Student(
        id: uuid.v4(),
        name: 'Aarav Sharma',
        studentId: 'CS-001',
        email: 'aarav.sharma@college.edu',
        phone: '9841234567',
        department: 'Computer Science',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=1',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        notes: 'Top performer in algorithms',
      ),
      Student(
        id: uuid.v4(),
        name: 'Priya Thapa',
        studentId: 'IT-002',
        email: 'priya.thapa@college.edu',
        phone: '9851234567',
        department: 'Information Technology',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=5',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Student(
        id: uuid.v4(),
        name: 'Rohan Karki',
        studentId: 'ME-003',
        email: 'rohan.karki@college.edu',
        phone: '9861234567',
        department: 'Mechanical',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=3',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Student(
        id: uuid.v4(),
        name: 'Sita Gurung',
        studentId: 'CE-004',
        email: 'sita.gurung@college.edu',
        phone: '9871234567',
        department: 'Civil',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=9',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Student(
        id: uuid.v4(),
        name: 'Bikash Rai',
        studentId: 'CS-005',
        email: 'bikash.rai@college.edu',
        phone: '9801234567',
        department: 'Computer Science',
        profilePictureUrl: 'https://i.pravatar.cc/150?img=8',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Flutter enthusiast',
      ),
    ];
    _students.addAll(samples);
    notifyListeners();
    await _saveToPrefs();
  }
}
