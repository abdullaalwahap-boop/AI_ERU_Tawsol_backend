import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/shared/sheet_handle.dart';
import 'package:flutter/material.dart';

class LinkInputSheet extends StatefulWidget {
  const LinkInputSheet({super.key, required this.onSend});

  final void Function(String url) onSend;

  static Future<void> show(
    BuildContext context, {
    required void Function(String url) onSend,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => LinkInputSheet(onSend: onSend),
    );
  }

  @override
  State<LinkInputSheet> createState() => _LinkInputSheetState();
}

class _LinkInputSheetState extends State<LinkInputSheet> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final url = _controller.text.trim();
    if (url.isEmpty) return;
    Navigator.pop(context);
    widget.onSend(url);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetHandle(),
          AppSpacing.h20,
          Text(
            'Send a Link',
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
          ),
          AppSpacing.h16,
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'https://',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.inputBgLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: const Icon(Icons.link_rounded, color: AppColors.primary),
            ),
          ),
          AppSpacing.h16,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _hasText ? _submit : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Send',
                style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
