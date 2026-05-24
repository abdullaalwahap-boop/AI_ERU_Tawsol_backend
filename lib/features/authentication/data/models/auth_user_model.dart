class AuthUserModel {
  const AuthUserModel({
    required this.userId,
    required this.uniCode,
    required this.name,
    required this.email,
    required this.typeCode,
    required this.level,
    this.department,
    this.profilePicture,
    this.isTemporaryPassword = false,
  });

  final int userId;
  final String uniCode;
  final String name;
  final String email;

  /// "STU" | "DR" | "TA" | "ADM"
  final String typeCode;

  /// 1–4 for students; 100 for admins.
  final int level;

  final String? department;
  final String? profilePicture;

  /// True when the backend signals the user must change their password.
  /// Maps from `current_password` in the UserOut schema.
  final bool isTemporaryPassword;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      userId: json['user_id'] as int,
      uniCode: json['uni_code'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      typeCode: json['type_code'] as String,
      level: json['level'] as int? ?? 0,
      department: json['department'] as String?,
      profilePicture: json['profile_picture'] as String?,
      isTemporaryPassword: json['current_password'] as bool? ?? false,
    );
  }

  AuthUserModel copyWith({
    String? name,
    String? profilePicture,
    bool? isTemporaryPassword,
  }) {
    return AuthUserModel(
      userId: userId,
      uniCode: uniCode,
      name: name ?? this.name,
      email: email,
      typeCode: typeCode,
      level: level,
      department: department,
      profilePicture: profilePicture ?? this.profilePicture,
      isTemporaryPassword: isTemporaryPassword ?? this.isTemporaryPassword,
    );
  }
}
