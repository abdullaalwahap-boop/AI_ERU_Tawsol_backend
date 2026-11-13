import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit(this._repo) : super(ForgetPasswordInitial());

  final AuthRepo _repo;

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoading());
    try {
      final res = await _repo.forgetPassword(email: email);
      if (isClosed) return;
      final returnedEmail = res['email'] as String? ?? email;
      final otp = (res['otp'] ?? res['otp_debug']) as String?;
      final msg = res['message'] as String?;
      emit(ForgetPasswordSuccess(returnedEmail, otp: otp, message: msg));
    } catch (e) {
      if (isClosed) return;
      emit(ForgetPasswordFailure(e.toString()));
    }
  }
}
