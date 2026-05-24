import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';

abstract class ProfileRepo {
  Future<ProfileUser> getProfile();
  Future<void> updateName(String name);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> sendContactUs(ContactRequest request);
}
