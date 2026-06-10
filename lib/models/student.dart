import 'dart:convert';

class Student {
  final String id;
  String name;
  String studentId;
  String email;
  String phone;
  String department;
  String profilePictureUrl;
  final DateTime createdAt;
  String? notes;

  Student({
    required this.id,
    required this.name,
    required this.studentId,
    required this.email,
    required this.phone,
    required this.department,
    required this.profilePictureUrl,
    required this.createdAt,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'studentId': studentId,
      'email': email,
      'phone': phone,
      'department': department,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      studentId: map['studentId'],
      email: map['email'],
      phone: map['phone'],
      department: map['department'],
      profilePictureUrl: map['profilePictureUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());
  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));

  Student copyWith({
    String? name,
    String? studentId,
    String? email,
    String? phone,
    String? department,
    String? profilePictureUrl,
    String? notes,
  }) {
    return Student(
      id: this.id,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}
