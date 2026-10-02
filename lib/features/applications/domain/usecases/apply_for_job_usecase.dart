import '../../../jobs/domain/entities/job.dart';
import '../repositories/applications_repository.dart';

class ApplyForJobUseCase {
  final ApplicationsRepository repository;

  ApplyForJobUseCase(this.repository);

  Future<bool> execute(Job job) {
    return repository.applyForJob(job);
  }
}
