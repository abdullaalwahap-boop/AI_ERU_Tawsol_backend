import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return AuthUserModel(
      userId: 1,
      uniCode: 'STU001',
      name: 'Test User',
      email: email,
      typeCode: 'STU',
      totalHours: 60,
      level: 2,
      // Mock: simulate first-login with a backend-generated temporary password.
      // Replace with actual backend field once API is integrated.
      isTemporaryPassword: true,
    );
  }

  @override
  Future<void> forgetPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }

  @override
  Future<void> verifyOtp({required String email, required String code}) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (code.length < 6) throw Exception('Invalid OTP code');
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));
  }
}
