import 'package:ai_eru_tawasol/features/profile/data/models/profile_role.dart';

class ProfileUser {
  final String id;

  /// University-issued code (e.g. "225040"). Distinct from [id] which is
  /// the internal database primary key used for API calls.
  final String uniCode;

  final String name;
  final String email;
  final ProfileRole role;
  final String? avatarUrl;
  final String department;
  final int? level;

  const ProfileUser({
    required this.id,
    required this.uniCode,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.department,
    this.level,
  });

  ProfileUser copyWith({String? name, String? avatarUrl}) => ProfileUser(
        id: id,
        uniCode: uniCode,
        name: name ?? this.name,
        email: email,
        role: role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        department: department,
        level: level,
      );
}
