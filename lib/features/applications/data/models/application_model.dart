import '../../../jobs/data/models/job_model.dart';
import '../../domain/entities/application.dart';

class ApplicationModel extends Application {
  ApplicationModel({
    required super.id,
    required super.job,
    required super.appliedDate,
    required super.status,
    required super.statusStep,
    required super.feedback,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] ?? '',
      job: JobModel.fromMap(Map<String, dynamic>.from(map['job'] ?? {})),
      appliedDate: DateTime.parse(map['appliedDate'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 'Applied',
      statusStep: map['statusStep'] ?? 'Resume Screening',
      feedback: map['feedback'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final jobModel = job is JobModel 
      ? job as JobModel 
      : JobModel(
          id: job.id,
          title: job.title,
          company: job.company,
          logoText: job.logoText,
          location: job.location,
          salary: job.salary,
          type: job.type,
          deadline: job.deadline,
          description: job.description,
          requirements: job.requirements,
          skillsNeeded: job.skillsNeeded,
          eligibility: job.eligibility,
        );

    return {
      'id': id,
      'job': jobModel.toMap(),
      'appliedDate': appliedDate.toIso8601String(),
      'status': status,
      'statusStep': statusStep,
      'feedback': feedback,
    };
  }
}
