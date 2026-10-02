import '../../../jobs/domain/entities/job.dart';
import '../entities/application.dart';

abstract class ApplicationsRepository {
  Future<List<Application>> getApplications();
  Future<bool> applyForJob(Job job);
  Future<void> updateApplicationStatus(String appId, String status, String statusStep, String feedback);
}
