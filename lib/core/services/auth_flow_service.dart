import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';

/// Determines the correct post-login navigation destination and manages
/// the first-login mandatory password change lifecycle.
///
/// Decision logic:
///   1. Backend signals temporary password via [AuthUserModel.isTemporaryPassword].
///   2. We also persist completion locally so re-logins skip the mandatory screen.
///   3. Both conditions must align: backend flag AND local flag not yet set.
class AuthFlowService {
  const AuthFlowService(this._storage);

  final LocalStorageService _storage;

  /// Returns the route path the app should navigate to after a successful login.
  Future<String> resolvePostLoginRoute(AuthUserModel user) async {
    if (!user.isTemporaryPassword) return AppRouter.kHomeView;
    final alreadyChanged = await _storage.getPasswordChanged(user.userId);
    if (alreadyChanged) return AppRouter.kHomeView;
    return AppRouter.kFirstLoginChangePasswordView;
  }

  /// Call this once the user successfully sets their new password.
  Future<void> markPasswordChanged(int userId) =>
      _storage.savePasswordChanged(userId: userId, value: true);
}
