import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser;

  @override
  Future<UserEntity?> login(String email, String password) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 1200));

    if (email.contains('@') && password.length >= 6) {
      _currentUser = UserEntity(
        id: 'student-2026',
        email: email,
        name: 'John Doe',
      );
      return _currentUser;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _currentUser;
  }
}
