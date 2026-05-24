part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

/// User authenticated successfully — proceed to Home.
final class LoginSuccess extends LoginState {
  final AuthUserModel user;
  const LoginSuccess(this.user);
  @override
  List<Object?> get props => [user];
}

/// User authenticated but must change their temporary password before continuing.
///
/// Navigation: go to [AppRouter.kFirstLoginChangePasswordView].
/// After the user changes their password, this state is never emitted again
/// for the same user (tracked via [LocalStorageService.getPasswordChanged]).
final class LoginPasswordChangeRequired extends LoginState {
  final AuthUserModel user;
  const LoginPasswordChangeRequired(this.user);
  @override
  List<Object?> get props => [user];
}

/// Authentication failed — display [errMessage] to the user.
final class LoginFailure extends LoginState {
  final String errMessage;
  const LoginFailure(this.errMessage);
  @override
  List<Object?> get props => [errMessage];
}
