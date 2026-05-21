import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:flutter/material.dart';

class ProfileIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final double size;
  final double iconSize;

  const ProfileIconBox({
    super.key,
    required this.icon,
    required this.color,
    required this.bg,
    this.size = 38,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.medium),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}
