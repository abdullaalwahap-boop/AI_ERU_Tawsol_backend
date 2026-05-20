import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Widget? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(title, style: AppTextStyles.heading3),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.heading4.copyWith(
                color: const Color(0xff9E9D97),
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}
