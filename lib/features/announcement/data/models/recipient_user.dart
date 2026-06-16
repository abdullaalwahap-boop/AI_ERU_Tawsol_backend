class RecipientUser {
  final int userId;
  final String name;
  final String uniCode;
  final String typeCode;
  final String? department;
  final int? level;

  const RecipientUser({
    required this.userId,
    required this.name,
    required this.uniCode,
    required this.typeCode,
    this.department,
    this.level,
  });

  factory RecipientUser.fromJson(Map<String, dynamic> json) => RecipientUser(
        userId: json['user_id'] as int,
        name: json['name'] as String,
        uniCode: json['uni_code'] as String,
        typeCode: json['type_code'] as String,
        department: json['department'] as String?,
        level: json['level'] as int?,
      );
}
