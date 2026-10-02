import '../entities/job.dart';
import '../repositories/jobs_repository.dart';

class GetJobDetailsUseCase {
  final JobsRepository repository;

  GetJobDetailsUseCase(this.repository);

  Future<Job?> execute(String id) {
    return repository.getJobById(id);
  }
}
