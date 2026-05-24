import 'package:ai_eru_tawasol/features/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<AuthUserModel> login({
    required String email,
    required String password,
  }) =>
      _datasource.login(email: email, password: password);

  @override
  Future<void> forgetPassword({required String email}) =>
      _datasource.forgotPassword(email: email);

  @override
  Future<String> verifyOtp({required String email, required String code}) =>
      _datasource.verifyOtp(email: email, otp: code);

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) =>
      _datasource.resetPassword(resetToken: resetToken, newPassword: newPassword);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _datasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  @override
  Future<void> logout() => _datasource.logout();
}
