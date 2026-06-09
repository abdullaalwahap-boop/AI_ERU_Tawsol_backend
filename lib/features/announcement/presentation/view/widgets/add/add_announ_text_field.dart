import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';

class AddAnnounTextField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final void Function(String) onChanged;
  final TextEditingController? controller;

  const AddAnnounTextField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorTextPrimary,
            letterSpacing: 0.1,
          ),
        ),
        AppSpacing.h8,
        Container(
          decoration: BoxDecoration(
            color: context.colorInputBg,
            borderRadius: AppRadius.large,
            border: Border.all(color: context.colorDivider, width: 1.2),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            onChanged: onChanged,
            style: AppTextStyles.bodyMedium.copyWith(
              color: context.colorTextPrimary,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: context.colorTextHint,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
