import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> execute(Profile profile) {
    return repository.saveProfile(profile);
  }
}
