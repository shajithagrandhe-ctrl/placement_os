import '../entities/job.dart';

abstract class JobsRepository {
  Future<List<Job>> getJobs();
  Future<Job?> getJobById(String id);
}
