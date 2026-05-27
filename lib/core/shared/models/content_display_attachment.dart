import 'package:flutter/material.dart';

class ContentDisplayAttachment {
  final String name;
  final String sizeLabel;
  final IconData icon;
  final Color iconColor;
  final String? url;

  const ContentDisplayAttachment({
    required this.name,
    required this.sizeLabel,
    required this.icon,
    required this.iconColor,
    this.url,
  });
}
