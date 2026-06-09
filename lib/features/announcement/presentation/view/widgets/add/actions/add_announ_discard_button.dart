import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';

class AddAnnounDiscardButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onTap;

  const AddAnnounDiscardButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.colorDivider, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: AppRadius.large),
        ),
        child: Text(
          'Discard',
          style: AppTextStyles.titleSmall.copyWith(
            color: context.colorTextSecondary,
          ),
        ),
      ),
    );
  }
}
