import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wraps flutter_secure_storage for JWT token and sensitive session data.
///
/// Uses AES encryption on Android and Keychain on iOS.
class SecureStorageService {
  static const _keyAccessToken = 'access_token';
  static const _keyUserId = 'user_id';
  static const _keyUserType = 'user_type';

  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  // ─── Access Token ────────────────────────────────────────────────────────────

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  Future<void> deleteAccessToken() => _storage.delete(key: _keyAccessToken);

  // ─── User Identity (cached for offline splash checks) ────────────────────────

  Future<void> saveUserId(int userId) =>
      _storage.write(key: _keyUserId, value: userId.toString());

  Future<int?> getUserId() async {
    final raw = await _storage.read(key: _keyUserId);
    return raw != null ? int.tryParse(raw) : null;
  }

  Future<void> saveUserType(String typeCode) =>
      _storage.write(key: _keyUserType, value: typeCode);

  Future<String?> getUserType() => _storage.read(key: _keyUserType);

  // ─── Session Clear ────────────────────────────────────────────────────────────

  /// Wipes all secure keys. Call on logout.
  Future<void> clearAll() => _storage.deleteAll();

  // ─── Convenience ──────────────────────────────────────────────────────────────

  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
