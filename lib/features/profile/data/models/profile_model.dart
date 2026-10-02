import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.name,
    required super.email,
    required super.rollNo,
    required super.department,
    required super.gpa,
    required super.skills,
    required super.resumeName,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      rollNo: map['rollNo'] ?? '',
      department: map['department'] ?? '',
      gpa: map['gpa'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      resumeName: map['resumeName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'rollNo': rollNo,
      'department': department,
      'gpa': gpa,
      'skills': skills,
      'resumeName': resumeName,
    };
  }
}
