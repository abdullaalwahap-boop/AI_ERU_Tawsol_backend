import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class EditMessageDialog extends StatefulWidget {
  final String initialText;

  const EditMessageDialog({super.key, required this.initialText});

  @override
  State<EditMessageDialog> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<EditMessageDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: context.colorSurface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      title: Text(
        l10n.editMessageAction,
        style: AppTextStyles.titleMedium
            .copyWith(color: context.colorTextPrimary),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: l10n.editMessageHint,
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: context.colorTextHint),
          filled: true,
          fillColor: context.colorInputBg,
          border: OutlineInputBorder(
            borderRadius: AppRadius.small,
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
        ),
        style: AppTextStyles.bodyMedium
            .copyWith(color: context.colorTextPrimary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: AppTextStyles.labelMedium.copyWith(
              color: context.colorTextSecondary,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final text = _controller.text.trim();
            Navigator.pop(context, text.isNotEmpty ? text : null);
          },
          child: Text(
            l10n.save,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
