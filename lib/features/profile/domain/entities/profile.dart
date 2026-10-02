class Profile {
  final String name;
  final String email;
  final String rollNo;
  final String department;
  final String gpa;
  final List<String> skills;
  final String resumeName;

  Profile({
    required this.name,
    required this.email,
    required this.rollNo,
    required this.department,
    required this.gpa,
    required this.skills,
    required this.resumeName,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? rollNo,
    String? department,
    String? gpa,
    List<String>? skills,
    String? resumeName,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      rollNo: rollNo ?? this.rollNo,
      department: department ?? this.department,
      gpa: gpa ?? this.gpa,
      skills: skills ?? this.skills,
      resumeName: resumeName ?? this.resumeName,
    );
  }
}
