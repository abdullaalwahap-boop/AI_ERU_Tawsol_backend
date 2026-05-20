import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class SettingsOptionTile<T> extends StatelessWidget {
  const SettingsOptionTile({
    super.key,
    this.icon,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onTap,
    this.subtitle,
  });

  final IconData? icon;
  final String title;
  final String? subtitle;
  final T value;
  final T groupValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return ListTile(
      leading: icon != null ? Icon(icon, size: 28) : null,
      title: Text(
        title,
        style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w400),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodyLarge)
          : null,
      trailing: Icon(
        size: 28,
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? Colors.blue : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
