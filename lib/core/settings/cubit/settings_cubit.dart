import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'settings_state.dart';

export 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._storage) : super(const SettingsState());

  final LocalStorageService _storage;

  // ── Load ──────────────────────────────────────────────────────────────────

  /// Restore persisted theme + locale. Call once before [runApp].
  Future<void> loadSettings() async {
    final themeMode = await _storage.getThemeMode();
    final locale = await _storage.getLocale();
    emit(SettingsState(themeMode: themeMode, locale: locale));
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  Future<void> setThemeMode(ThemeMode mode) async {
    await _storage.saveThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  // ── Locale ────────────────────────────────────────────────────────────────

  Future<void> setLocale(Locale locale) async {
    await _storage.saveLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
