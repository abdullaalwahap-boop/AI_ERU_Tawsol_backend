import 'package:flutter/material.dart';

class AttachmentDisplayData {
  final String name;
  final String sizeLabel;
  final IconData icon;
  final Color iconColor;
  final String? url;
  final bool isImage;

  const AttachmentDisplayData({
    required this.name,
    required this.sizeLabel,
    required this.icon,
    required this.iconColor,
    this.url,
    this.isImage = false,
  });
}
