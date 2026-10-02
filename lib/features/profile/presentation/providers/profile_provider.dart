import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/save_profile_usecase.dart';

// 1. Local Data Source Provider
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSourceImpl();
});

// 2. Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.watch(profileLocalDataSourceProvider);
  return ProfileRepositoryImpl(localDataSource);
});

// 3. Use Case Providers
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

final saveProfileUseCaseProvider = Provider<SaveProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return SaveProfileUseCase(repository);
});

// 4. State Notifier Provider
class ProfileNotifier extends StateNotifier<AsyncValue<Profile>> {
  final GetProfileUseCase _getProfileUseCase;
  final SaveProfileUseCase _saveProfileUseCase;

  ProfileNotifier({
    required GetProfileUseCase getProfileUseCase,
    required SaveProfileUseCase saveProfileUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _saveProfileUseCase = saveProfileUseCase,
        super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _getProfileUseCase.execute();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveProfile(Profile profile) async {
    try {
      await _saveProfileUseCase.execute(profile);
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<Profile>>((ref) {
  final getProfileUseCase = ref.watch(getProfileUseCaseProvider);
  final saveProfileUseCase = ref.watch(saveProfileUseCaseProvider);
  return ProfileNotifier(
    getProfileUseCase: getProfileUseCase,
    saveProfileUseCase: saveProfileUseCase,
  );
});
