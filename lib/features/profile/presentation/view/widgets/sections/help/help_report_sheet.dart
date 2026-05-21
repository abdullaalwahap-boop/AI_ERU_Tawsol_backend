import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

enum HelpReportCategory {
  bug('Bug'),
  suggestion('Suggestion'),
  content('Content'),
  other('Other');

  final String label;
  const HelpReportCategory(this.label);
}

class HelpReportSheet extends StatefulWidget {
  const HelpReportSheet({super.key});

  @override
  State<HelpReportSheet> createState() => _HelpReportSheetState();
}

class _HelpReportSheetState extends State<HelpReportSheet> {
  final _ctrl = TextEditingController();
  HelpReportCategory _category = HelpReportCategory.bug;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.bottomSheet,
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xxl,
          AppSpacing.lg,
          AppSpacing.xxl,
          AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: AppRadius.circular,
                ),
              ),
            ),
            AppSpacing.h20,
            Text(
              'Report an Issue',
              style: AppTextStyles.heading4
                  .copyWith(color: AppColors.textPrimary),
            ),
            AppSpacing.h4,
            Text(
              'Help us improve AI Connect',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.h20,
            Text(
              'Category',
              style: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.h8,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: HelpReportCategory.values.map((cat) {
                  final sel = cat == _category;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: GestureDetector(
                      onTap: () => setState(() => _category = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs + 1,
                        ),
                        decoration: BoxDecoration(
                          color:
                              sel ? AppColors.primary : AppColors.inputBgLight,
                          borderRadius: AppRadius.circular,
                          border:
                              sel ? null : Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          cat.label,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: sel
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            AppSpacing.h16,
            TextField(
              controller: _ctrl,
              maxLines: 4,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Describe the issue in detail…',
                hintStyle: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.inputBgLight,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.large,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.lg),
              ),
            ),
            AppSpacing.h20,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Report submitted. Thank you!',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: Colors.white),
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.large),
                      margin: AppSpacing.pagePadding,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  elevation: 0,
                ),
                child: Text(
                  'Submit Report',
                  style: AppTextStyles.buttonMedium
                      .copyWith(color: AppColors.textOnPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
