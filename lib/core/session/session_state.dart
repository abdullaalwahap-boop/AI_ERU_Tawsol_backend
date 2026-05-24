part of 'session_cubit.dart';

sealed class SessionState {}

/// Initial state before any session check has been performed.
final class SessionInitial extends SessionState {}

/// A valid session exists — user is authenticated.
final class SessionAuthenticated extends SessionState {
  SessionAuthenticated({required this.role, required this.userId});

  final AppRole role;
  final int userId;
}

/// No valid session — user must log in.
final class SessionUnauthenticated extends SessionState {}
