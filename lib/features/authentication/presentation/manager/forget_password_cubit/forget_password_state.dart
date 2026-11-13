part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();
  @override
  List<Object?> get props => [];
}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String email;
  final String? otp;
  final String? message;

  const ForgetPasswordSuccess(this.email, {this.otp, this.message});

  @override
  List<Object?> get props => [email, otp, message];
}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errMessage;
  const ForgetPasswordFailure(this.errMessage);
  @override
  List<Object?> get props => [errMessage];
}
