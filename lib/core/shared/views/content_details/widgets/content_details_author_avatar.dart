import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';

class ContentDetailsAuthorAvatar extends StatelessWidget {
  final ContentDisplayItem item;
  const ContentDetailsAuthorAvatar({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            item.typeColor.withValues(alpha: 0.15),
            item.typeColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.large,
        border: Border.all(
          color: item.typeColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: item.isFromAdmin
          ? Icon(Icons.admin_panel_settings_rounded,
              color: item.typeColor, size: 28)
          : Center(
              child: Text(
                item.authorInitials,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: item.typeColor,
                ),
              ),
            ),
    );
  }
}
