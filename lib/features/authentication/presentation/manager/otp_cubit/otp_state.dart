part of 'otp_cubit.dart';

sealed class OtpState extends Equatable {
  const OtpState();
  @override
  List<Object?> get props => [];
}

final class OtpInitial extends OtpState {}

final class OtpLoading extends OtpState {}

final class OtpResending extends OtpState {}

final class OtpSuccess extends OtpState {
  /// The short-lived reset token returned by the backend after OTP validation.
  /// Must be forwarded to the Reset Password screen.
  final String resetToken;

  const OtpSuccess(this.resetToken);

  @override
  List<Object?> get props => [resetToken];
}

final class OtpFailure extends OtpState {
  final String errMessage;
  const OtpFailure(this.errMessage);
  @override
  List<Object?> get props => [errMessage];
}
