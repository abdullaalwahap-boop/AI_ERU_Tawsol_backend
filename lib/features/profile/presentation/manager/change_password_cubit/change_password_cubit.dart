import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ProfileRepo _repo;

  ChangePasswordCubit(this._repo) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (isClosed) return;
    emit(ChangePasswordLoading());
    try {
      await _repo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (isClosed) return;
      emit(ChangePasswordSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(ChangePasswordError(
        e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
