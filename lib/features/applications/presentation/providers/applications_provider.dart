import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../jobs/domain/entities/job.dart';
import '../../domain/entities/application.dart';
import '../../domain/repositories/applications_repository.dart';
import '../../data/repositories/applications_repository_impl.dart';
import '../../data/datasources/applications_local_data_source.dart';
import '../../domain/usecases/get_applications_usecase.dart';
import '../../domain/usecases/apply_for_job_usecase.dart';

// 1. Local Data Source Provider
final applicationsLocalDataSourceProvider = Provider<ApplicationsLocalDataSource>((ref) {
  return ApplicationsLocalDataSourceImpl();
});

// 2. Repository Provider
final applicationsRepositoryProvider = Provider<ApplicationsRepository>((ref) {
  final localDataSource = ref.watch(applicationsLocalDataSourceProvider);
  return ApplicationsRepositoryImpl(localDataSource);
});

// 3. Use Case Providers
final getApplicationsUseCaseProvider = Provider<GetApplicationsUseCase>((ref) {
  final repository = ref.watch(applicationsRepositoryProvider);
  return GetApplicationsUseCase(repository);
});

final applyForJobUseCaseProvider = Provider<ApplyForJobUseCase>((ref) {
  final repository = ref.watch(applicationsRepositoryProvider);
  return ApplyForJobUseCase(repository);
});

// 4. State Notifier
class ApplicationsNotifier extends StateNotifier<List<Application>> {
  final GetApplicationsUseCase _getApplicationsUseCase;
  final ApplyForJobUseCase _applyForJobUseCase;

  ApplicationsNotifier({
    required GetApplicationsUseCase getApplicationsUseCase,
    required ApplyForJobUseCase applyForJobUseCase,
  })  : _getApplicationsUseCase = getApplicationsUseCase,
        _applyForJobUseCase = applyForJobUseCase,
        super([]) {
    loadApplications();
  }

  Future<void> loadApplications() async {
    final list = await _getApplicationsUseCase.execute();
    state = list;
  }

  Future<bool> applyForJob(Job job) async {
    final success = await _applyForJobUseCase.execute(job);
    if (success) {
      await loadApplications();
    }
    return success;
  }
}

final applicationsProvider = StateNotifierProvider<ApplicationsNotifier, List<Application>>((ref) {
  final getApplicationsUseCase = ref.watch(getApplicationsUseCaseProvider);
  final applyForJobUseCase = ref.watch(applyForJobUseCaseProvider);
  
  return ApplicationsNotifier(
    getApplicationsUseCase: getApplicationsUseCase,
    applyForJobUseCase: applyForJobUseCase,
  );
});
