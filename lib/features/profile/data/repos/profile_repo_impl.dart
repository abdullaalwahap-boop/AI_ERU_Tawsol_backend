import 'package:ai_eru_tawasol/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/contact_model.dart';
import 'package:ai_eru_tawasol/features/profile/data/models/profile_models.dart';
import 'package:ai_eru_tawasol/features/profile/data/repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  const ProfileRepoImpl(this._datasource);

  final ProfileRemoteDatasource _datasource;

  @override
  Future<ProfileUser> getProfile() => _datasource.getProfile();

  @override
  Future<void> updateName(String name) => _datasource.updateName(name);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _datasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  @override
  Future<void> sendContactUs(ContactRequest request) =>
      _datasource.sendContactUs(request);
}
