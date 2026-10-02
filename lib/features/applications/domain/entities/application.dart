import '../../../jobs/domain/entities/job.dart';

class Application {
  final String id;
  final Job job;
  final DateTime appliedDate;
  final String status; // 'Applied', 'Aptitude Test', 'Interview', 'Selected', 'Rejected'
  final String statusStep; // e.g. "Round 2: Technical Interview"
  final String feedback;

  Application({
    required this.id,
    required this.job,
    required this.appliedDate,
    required this.status,
    required this.statusStep,
    required this.feedback,
  });

  Application copyWith({
    String? status,
    String? statusStep,
    String? feedback,
  }) {
    return Application(
      id: id,
      job: job,
      appliedDate: appliedDate,
      status: status ?? this.status,
      statusStep: statusStep ?? this.statusStep,
      feedback: feedback ?? this.feedback,
    );
  }
}
