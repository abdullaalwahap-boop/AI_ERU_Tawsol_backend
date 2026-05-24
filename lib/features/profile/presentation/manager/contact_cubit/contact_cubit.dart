import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit(this._repo) : super(ContactInitial());

  final ProfileRepo _repo;

  Future<void> send(ContactRequest request) async {
    emit(ContactLoading());
    try {
      await _repo.sendContactUs(request);
      if (isClosed) return;
      emit(ContactSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(ContactFailure(e.toString()));
    }
  }
}
