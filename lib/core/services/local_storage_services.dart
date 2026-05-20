import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _keyRememberMe = 'rememberMe';
  static const _keyEmail = 'savedEmail';
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyHasSeenOnboarding = 'hasSeenOnboarding';

  // ─── Remember Me (email pre-fill) ───────────────────────────────────────────

  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  Future<String> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? '';
  }

  Future<void> clearSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
  }

  // ─── Session (keep logged in) ────────────────────────────────────────────────

  Future<void> saveIsLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> clearIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
  }

  // ─── Onboarding ──────────────────────────────────────────────────────────────

  Future<void> saveHasSeenOnboarding(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSeenOnboarding, value);
  }

  Future<bool> getHasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }
}
