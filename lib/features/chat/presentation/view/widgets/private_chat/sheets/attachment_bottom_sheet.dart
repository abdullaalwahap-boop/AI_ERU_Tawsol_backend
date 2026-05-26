import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/sheet_handle.dart';
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/sheets/attachment_tile.dart';

class AttachmentBottomSheet extends StatelessWidget {
  final void Function(AttachmentOption) onSelected;

  const AttachmentBottomSheet({super.key, required this.onSelected});

  static Future<void> show(
    BuildContext context, {
    required void Function(AttachmentOption) onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => AttachmentBottomSheet(onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          AppSpacing.h20,
          Text(
            'Share Content',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          AppSpacing.h8,
          Text(
            'Choose what you would like to send',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          AppSpacing.h28,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AttachmentOption.camera,
              AttachmentOption.gallery,
              AttachmentOption.document,
            ]
                .map((opt) => AttachmentTile(
                      option: opt,
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(opt);
                      },
                    ))
                .toList(),
          ),
          AppSpacing.h16,
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.medium),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
