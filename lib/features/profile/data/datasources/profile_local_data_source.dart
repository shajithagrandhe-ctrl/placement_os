import 'package:hive/hive.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> saveProfile(ProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Box _box = HiveService.profileBox;

  @override
  Future<ProfileModel> getProfile() async {
    final name = _box.get('name', defaultValue: 'John Doe') as String;
    final email = _box.get('email', defaultValue: 'john.doe@university.edu') as String;
    final rollNo = _box.get('rollNo', defaultValue: 'CS20261042') as String;
    final department = _box.get('department', defaultValue: 'Computer Science & Engineering') as String;
    final gpa = _box.get('gpa', defaultValue: '9.2') as String;
    
    final dynamicSkills = _box.get('skills', defaultValue: ['Flutter', 'Dart', 'Clean Architecture', 'Riverpod', 'Hive']) as List;
    final skills = List<String>.from(dynamicSkills);
    
    final resumeName = _box.get('resumeName', defaultValue: 'John_Doe_Resume_2026.pdf') as String;

    return ProfileModel(
      name: name,
      email: email,
      rollNo: rollNo,
      department: department,
      gpa: gpa,
      skills: skills,
      resumeName: resumeName,
    );
  }

  @override
  Future<void> saveProfile(ProfileModel profile) async {
    await _box.putAll(profile.toMap());
  }
}
