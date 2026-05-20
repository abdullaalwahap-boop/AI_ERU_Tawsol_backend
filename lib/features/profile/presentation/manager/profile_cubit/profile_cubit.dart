import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _repo;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> load() async {
    if (isClosed) return;
    emit(ProfileLoading());
    try {
      final user = await _repo.getProfile();
      if (isClosed) return;
      emit(ProfileLoaded(user));
    } catch (e) {
      if (isClosed) return;
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateName(String name) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    if (isClosed) return;
    emit(ProfileUpdating(current.user));
    try {
      await _repo.updateName(name);
      final updated = current.user.copyWith(name: name);
      if (isClosed) return;
      emit(ProfileUpdateSuccess(updated));
      emit(ProfileLoaded(updated));
    } catch (e) {
      if (isClosed) return;
      emit(ProfileError(e.toString()));
      emit(ProfileLoaded(current.user));
    }
  }
}
