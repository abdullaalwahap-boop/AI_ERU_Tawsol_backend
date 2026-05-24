import 'package:ai_eru_tawasol/core/services/secure_storage_service.dart';
import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'session_state.dart';

/// Global session cubit — single source of truth for the authenticated
/// user's identity (role + userId).
///
/// Provided at the root of the widget tree so every feature can access it
/// via [BlocBuilder] or [context.read] without coupling to the auth feature.
class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._storage) : super(SessionInitial());

  final SecureStorageService _storage;

  // ── Initializers ──────────────────────────────────────────────────────────

  /// Called during splash to restore a previously active session.
  /// Emits [SessionAuthenticated] when credentials are found in secure
  /// storage, [SessionUnauthenticated] otherwise.
  Future<void> restoreFromStorage() async {
    final typeCode = await _storage.getUserType();
    final userId = await _storage.getUserId();
    if (typeCode == null || userId == null) {
      emit(SessionUnauthenticated());
      return;
    }
    emit(SessionAuthenticated(
      role: AppRole.fromTypeCode(typeCode),
      userId: userId,
    ));
  }

  /// Called immediately after a successful login with the backend response.
  void initFromAuth({required String typeCode, required int userId}) {
    emit(SessionAuthenticated(
      role: AppRole.fromTypeCode(typeCode),
      userId: userId,
    ));
  }

  /// Called on logout — clears the in-memory session.
  /// Storage clearing is handled separately by [AuthRepo.logout].
  void clear() => emit(SessionUnauthenticated());
}
