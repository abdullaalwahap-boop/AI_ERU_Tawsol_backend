class AuthUserModel {
  final int userId;
  final String uniCode;
  final String name;
  final String email;
  final String typeCode;
  final int totalHours;
  final int level;
  final String? profilePicture;

  /// True when the backend assigned a system-generated temporary password.
  /// Backend fields: `is_temporary_password`, `requires_password_reset`, `first_login`.
  final bool isTemporaryPassword;

  const AuthUserModel({
    required this.userId,
    required this.uniCode,
    required this.name,
    required this.email,
    required this.typeCode,
    required this.totalHours,
    required this.level,
    this.profilePicture,
    this.isTemporaryPassword = false,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      userId: json['user_id'] as int,
      uniCode: json['uni_code'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      typeCode: json['type_code'] as String,
      totalHours: json['total_hours'] as int,
      level: json['level'] as int,
      profilePicture: json['profile_picture'] as String?,
      isTemporaryPassword: json['is_temporary_password'] as bool? ??
          json['requires_password_reset'] as bool? ??
          json['first_login'] as bool? ??
          false,
    );
  }
}
