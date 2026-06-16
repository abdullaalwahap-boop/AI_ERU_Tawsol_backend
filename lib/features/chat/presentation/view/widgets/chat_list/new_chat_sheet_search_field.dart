import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class NewChatSheetSearchField extends StatelessWidget {
  final TextEditingController controller;

  const NewChatSheetSearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.bodyMedium
            .copyWith(color: context.colorTextPrimary),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).searchByNameOrId,
          hintStyle: AppTextStyles.bodyMedium
              .copyWith(color: context.colorTextHint),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colorTextHint,
            size: 20,
          ),
          filled: true,
          fillColor: context.colorInputBg,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
