import '../entities/job.dart';
import '../repositories/jobs_repository.dart';

class GetJobsUseCase {
  final JobsRepository repository;

  GetJobsUseCase(this.repository);

  Future<List<Job>> execute() {
    return repository.getJobs();
  }
}
