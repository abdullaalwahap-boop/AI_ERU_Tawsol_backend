import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/quiz/data/models/quiz_answer_result.dart';

class OptionTile extends StatelessWidget {
  final String optionKey;
  final String text;
  final bool isSelected;
  final bool isAnswered;
  final QuizAnswerResult? result;
  final VoidCallback? onTap;

  const OptionTile({
    super.key,
    required this.optionKey,
    required this.text,
    required this.isSelected,
    required this.isAnswered,
    required this.result,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = result?.correctAnswer == optionKey;
    final isWrong = isSelected && result?.correct == false;

    Color bg = context.colorSurface;
    Color border = context.colorBorder;
    Color labelBg = context.colorBackground;
    Color labelText = context.colorTextSecondary;
    Color textColor = context.colorTextPrimary;
    IconData? trailingIcon;

    if (isAnswered) {
      if (isCorrect) {
        bg = AppColors.successLight;
        border = AppColors.success;
        labelBg = AppColors.success;
        labelText = Colors.white;
        textColor = AppColors.success;
        trailingIcon = Icons.check_circle_rounded;
      } else if (isWrong) {
        bg = AppColors.errorLight;
        border = AppColors.error;
        labelBg = AppColors.error;
        labelText = Colors.white;
        textColor = AppColors.error;
        trailingIcon = Icons.cancel_rounded;
      }
    } else if (isSelected) {
      bg = AppColors.infoLight;
      border = AppColors.accent;
      labelBg = AppColors.accent;
      labelText = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.large,
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                optionKey,
                style: AppTextStyles.labelMedium.copyWith(
                  color: labelText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            AppSpacing.w12,
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(color: textColor),
              ),
            ),
            if (trailingIcon != null) ...[
              AppSpacing.w8,
              Icon(trailingIcon,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
