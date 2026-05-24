import 'package:ai_eru_tawasol/features/authentication/data/repos/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repo) : super(OtpInitial());

  final AuthRepo _repo;

  // ─── Verify ───────────────────────────────────────────────────────────────────

  Future<void> verifyOtp({
    required String email,
    required String code,
  }) async {
    emit(OtpLoading());
    try {
      final resetToken = await _repo.verifyOtp(email: email, code: code);
      if (isClosed) return;
      emit(OtpSuccess(resetToken));
    } catch (e) {
      if (isClosed) return;
      emit(OtpFailure(e.toString()));
    }
  }

  // ─── Resend ───────────────────────────────────────────────────────────────────

  Future<void> resendOtp({required String email}) async {
    emit(OtpResending());
    try {
      await _repo.forgetPassword(email: email);
      if (isClosed) return;
      emit(OtpInitial());
    } catch (e) {
      if (isClosed) return;
      emit(OtpInitial());
    }
  }
}
