import 'package:ai_eru_tawasol/features/authentication/data/models/auth_user_model.dart';
import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(LoginInitial());

  final AuthRepo _repo;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final user = await _repo.login(email: email, password: password);
      if (isClosed) return;
      emit(_resolveState(user));
    } catch (e) {
      if (isClosed) return;
      emit(LoginFailure(e.toString()));
    }
  }

  // ─── Private ──────────────────────────────────────────────────────────────────

  /// Source of truth is the backend field `is_first_login` (mapped to
  /// [AuthUserModel.isTemporaryPassword]).
  ///
  /// - Backend returns `is_first_login: true`  → [LoginPasswordChangeRequired].
  /// - Backend returns `is_first_login: false` → [LoginSuccess].
  ///
  /// This decision is device-independent: uninstalling the app or clearing
  /// storage has no effect because the flag lives in the database.
  LoginState _resolveState(AuthUserModel user) {
    if (user.isTemporaryPassword) return LoginPasswordChangeRequired(user);
    return LoginSuccess(user);
  }
}
