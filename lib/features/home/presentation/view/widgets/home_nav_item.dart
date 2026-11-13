import 'package:flutter/material.dart';

class HomeNavItem {
  final IconData icon;
  final String label;
  final int badgeCount;

  const HomeNavItem({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
  });
}
