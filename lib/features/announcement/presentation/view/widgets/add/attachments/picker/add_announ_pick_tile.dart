import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/attachments/picker/add_announ_pick_option.dart';

class AddAnnounPickTile extends StatelessWidget {
  final AddAnnounPickOption option;
  final VoidCallback onTap;

  const AddAnnounPickTile({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: option.color.withValues(alpha: 0.06),
          borderRadius: AppRadius.large,
          border: Border.all(
            color: option.color.withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: option.color.withValues(alpha: 0.12),
                borderRadius: AppRadius.medium,
              ),
              child: Icon(option.icon, size: 20, color: option.color),
            ),
            const SizedBox(height: 7),
            Text(
              option.label,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
