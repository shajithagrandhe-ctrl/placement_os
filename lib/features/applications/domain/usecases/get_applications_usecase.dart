import '../entities/application.dart';
import '../repositories/applications_repository.dart';

class GetApplicationsUseCase {
  final ApplicationsRepository repository;

  GetApplicationsUseCase(this.repository);

  Future<List<Application>> execute() {
    return repository.getApplications();
  }
}
