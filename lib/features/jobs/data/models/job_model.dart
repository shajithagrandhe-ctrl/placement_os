import '../../domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.title,
    required super.company,
    required super.logoText,
    required super.location,
    required super.salary,
    required super.type,
    required super.deadline,
    required super.description,
    required super.requirements,
    required super.skillsNeeded,
    required super.eligibility,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      logoText: map['logoText'] ?? '',
      location: map['location'] ?? '',
      salary: map['salary'] ?? '',
      type: map['type'] ?? '',
      deadline: map['deadline'] ?? '',
      description: map['description'] ?? '',
      requirements: List<String>.from(map['requirements'] ?? []),
      skillsNeeded: List<String>.from(map['skillsNeeded'] ?? []),
      eligibility: map['eligibility'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'logoText': logoText,
      'location': location,
      'salary': salary,
      'type': type,
      'deadline': deadline,
      'description': description,
      'requirements': requirements,
      'skillsNeeded': skillsNeeded,
      'eligibility': eligibility,
    };
  }
}
