import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

/// Minimal MaterialApp that provides AppLocalizations + brightness-aware
/// ThemeData. Use as the root in all widget tests.
///
/// BlocProviders and other ancestors should be passed as part of [child]
/// or wrapped around the returned widget.
Widget testWrap(Widget child, {ThemeMode themeMode = ThemeMode.light}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
    themeMode: themeMode,
    home: child,
  );
}
