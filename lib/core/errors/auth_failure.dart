/// Typed authentication failures used by auth cubits.
///
/// All constructors accept a [errMessage] for display in the UI.
/// The [NetworkException] class handles low-level HTTP/network errors;
/// these types represent higher-level auth business-logic failures.
abstract class AuthFailure implements Exception {
  const AuthFailure(this.errMessage);

  final String errMessage;

  @override
  String toString() => errMessage;
}

final class InvalidCredentials extends AuthFailure {
  const InvalidCredentials([super.errMessage = 'Invalid email or password.']);
}

final class UserNotFound extends AuthFailure {
  const UserNotFound([super.errMessage = 'No account found with this email.']);
}

final class UserDisabled extends AuthFailure {
  const UserDisabled([super.errMessage = 'Your account has been disabled.']);
}

final class OtpExpired extends AuthFailure {
  const OtpExpired([super.errMessage = 'The OTP has expired. Please request a new one.']);
}

final class OtpInvalid extends AuthFailure {
  const OtpInvalid([super.errMessage = 'Invalid OTP code. Please try again.']);
}

final class WeakPassword extends AuthFailure {
  const WeakPassword([
    super.errMessage =
        'Password must be at least 8 characters with upper, lower, digit and special character.',
  ]);
}

final class UnauthorizedFailure extends AuthFailure {
  const UnauthorizedFailure([super.errMessage = 'Session expired. Please log in again.']);
}

final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([super.errMessage = 'An unexpected error occurred.']);
}
