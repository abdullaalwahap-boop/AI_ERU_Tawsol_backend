import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._repo) : super(ResetPasswordInitial());

  final AuthRepo _repo;

  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _repo.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
      );
      if (isClosed) return;
      emit(ResetPasswordSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(ResetPasswordFailure(e.toString()));
    }
  }
}
