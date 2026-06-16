import 'package:flutter/material.dart';

enum ProfileThemeOption {
  light('Light', Icons.light_mode_rounded),
  dark('Dark', Icons.dark_mode_rounded),
  system('System', Icons.brightness_auto_rounded);

  final String label;
  final IconData icon;
  const ProfileThemeOption(this.label, this.icon);
}
