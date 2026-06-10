import 'package:ai_eru_tawasol/core/services/local_storage_services.dart';
import 'package:ai_eru_tawasol/core/settings/cubit/settings_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalStorage extends Mock implements LocalStorageService {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
    registerFallbackValue(const Locale('en'));
  });

  late _MockLocalStorage storage;

  setUp(() {
    storage = _MockLocalStorage();
    // Provide stubs needed by loadSettings
    when(() => storage.getThemeMode()).thenAnswer((_) async => ThemeMode.light);
    when(() => storage.getLocale()).thenAnswer((_) async => const Locale('en'));
    when(() => storage.saveThemeMode(any())).thenAnswer((_) async {});
    when(() => storage.saveLocale(any())).thenAnswer((_) async {});
  });

  group('SettingsCubit', () {
    test('initial state has light theme and English locale', () {
      final cubit = SettingsCubit(storage);
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(cubit.state.locale, const Locale('en'));
    });

    blocTest<SettingsCubit, SettingsState>(
      'loadSettings emits state from storage',
      build: () {
        when(() => storage.getThemeMode())
            .thenAnswer((_) async => ThemeMode.dark);
        when(() => storage.getLocale())
            .thenAnswer((_) async => const Locale('ar'));
        return SettingsCubit(storage);
      },
      act: (c) => c.loadSettings(),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.themeMode, 'theme', ThemeMode.dark)
            .having((s) => s.locale.languageCode, 'locale', 'ar'),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'setThemeMode persists and emits new theme',
      build: () => SettingsCubit(storage),
      act: (c) => c.setThemeMode(ThemeMode.dark),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.themeMode, 'theme', ThemeMode.dark),
      ],
      verify: (_) {
        verify(() => storage.saveThemeMode(ThemeMode.dark)).called(1);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'setLocale persists and emits new locale',
      build: () => SettingsCubit(storage),
      act: (c) => c.setLocale(const Locale('ar')),
      expect: () => [
        isA<SettingsState>()
            .having((s) => s.locale.languageCode, 'locale', 'ar'),
      ],
      verify: (_) {
        verify(() => storage.saveLocale(const Locale('ar'))).called(1);
      },
    );

    test('SettingsState.copyWith updates themeMode', () {
      const state = SettingsState();
      final updated = state.copyWith(themeMode: ThemeMode.dark);
      expect(updated.themeMode, ThemeMode.dark);
      expect(updated.locale, state.locale);
    });

    test('SettingsState.copyWith updates locale', () {
      const state = SettingsState();
      final updated = state.copyWith(locale: const Locale('ar'));
      expect(updated.locale.languageCode, 'ar');
      expect(updated.themeMode, state.themeMode);
    });

    test('SettingsState equality works via Equatable', () {
      const s1 = SettingsState(themeMode: ThemeMode.dark, locale: Locale('en'));
      const s2 = SettingsState(themeMode: ThemeMode.dark, locale: Locale('en'));
      expect(s1, equals(s2));
    });
  });
}
