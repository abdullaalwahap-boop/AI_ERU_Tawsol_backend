import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';

abstract class AuthRepo {
  /// Authenticates the user and returns their profile.
  ///
  /// Throws [NetworkException] or [AuthFailure] on failure.
  Future<AuthUserModel> login({
    required String email,
    required String password,
  });

  /// Sends an OTP to [email]. Throws on unknown email or network error.
  Future<void> forgetPassword({required String email});

  /// Validates [code] for [email] and returns a short-lived `reset_token`.
  ///
  /// The token is needed by [resetPassword] and should be passed through
  /// the UI navigation stack (not stored persistently).
  Future<String> verifyOtp({required String email, required String code});

  /// Resets the password using the token returned by [verifyOtp].
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });

  /// Changes the password for the currently logged-in user.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Blacklists the current JWT and clears local session data.
  Future<void> logout();
}
