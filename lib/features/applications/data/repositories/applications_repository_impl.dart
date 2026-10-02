import '../../../jobs/domain/entities/job.dart';
import '../../domain/entities/application.dart';
import '../../domain/repositories/applications_repository.dart';
import '../datasources/applications_local_data_source.dart';
import '../models/application_model.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  final ApplicationsLocalDataSource localDataSource;

  ApplicationsRepositoryImpl(this.localDataSource);

  @override
  Future<List<Application>> getApplications() async {
    return await localDataSource.getApplications();
  }

  @override
  Future<bool> applyForJob(Job job) async {
    final existingApps = await localDataSource.getApplications();
    if (existingApps.any((app) => app.job.id == job.id)) {
      return false;
    }

    final newApp = ApplicationModel(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      job: job,
      appliedDate: DateTime.now(),
      status: 'Applied',
      statusStep: 'Resume Screening',
      feedback: 'Application submitted successfully. Awaiting resume review.',
    );

    await localDataSource.saveApplication(newApp);
    return true;
  }

  @override
  Future<void> updateApplicationStatus(String appId, String status, String statusStep, String feedback) async {
    final existingApps = await localDataSource.getApplications();
    try {
      final app = existingApps.firstWhere((a) => a.id == appId);
      final updatedApp = ApplicationModel(
        id: app.id,
        job: app.job,
        appliedDate: app.appliedDate,
        status: status,
        statusStep: statusStep,
        feedback: feedback,
      );
      await localDataSource.updateApplication(updatedApp);
    } catch (_) {}
  }
}
