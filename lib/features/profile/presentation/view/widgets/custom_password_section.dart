import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/profile/presentation/view/widgets/custom_change_password_text_field_form.dart';
import 'package:flutter/material.dart';

class CustomPasswordSection extends StatelessWidget {
  const CustomPasswordSection({
    super.key,
    required this.title,
    this.controller,
    this.onChanged,
  });

  final String title;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.w400),
          ),
          CustomChangePasswordTextFieldForm(
            controller: controller,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
