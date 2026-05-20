import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  static const _mockUser = ProfileUser(
    id: '2100123',
    name: 'Ziad Tamer',
    email: 'ziad.tamer@eru.edu.eg',
    role: ProfileRole.student,
    department: 'Computer Science',
    level: 3,
  );

  ProfileUser _current = _mockUser;

  @override
  Future<ProfileUser> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _current;
  }

  @override
  Future<void> updateName(String name) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _current = _current.copyWith(name: name);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (currentPassword == 'wrongpassword') {
      throw Exception('Current password is incorrect.');
    }
  }
}
