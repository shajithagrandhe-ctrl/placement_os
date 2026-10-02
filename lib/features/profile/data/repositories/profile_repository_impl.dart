import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Profile> getProfile() async {
    return await localDataSource.getProfile();
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    final model = ProfileModel(
      name: profile.name,
      email: profile.email,
      rollNo: profile.rollNo,
      department: profile.department,
      gpa: profile.gpa,
      skills: profile.skills,
      resumeName: profile.resumeName,
    );
    await localDataSource.saveProfile(model);
  }
}
