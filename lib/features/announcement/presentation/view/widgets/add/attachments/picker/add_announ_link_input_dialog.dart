import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class AddAnnounLinkInputDialog extends StatefulWidget {
  const AddAnnounLinkInputDialog({super.key});

  @override
  State<AddAnnounLinkInputDialog> createState() =>
      _AddAnnounLinkInputDialogState();
}

class _AddAnnounLinkInputDialogState extends State<AddAnnounLinkInputDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _confirm() {
    final value = _controller.text.trim();
    if (!_isValidUrl(value)) {
      setState(() => _error = 'Please enter a valid URL (https://…)');
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlarge),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xff059669).withValues(alpha: 0.1),
                    borderRadius: AppRadius.medium,
                  ),
                  child: const Icon(Icons.link_rounded,
                      size: 18, color: Color(0xff059669)),
                ),
                AppSpacing.w12,
                Text(
                  'Add Link',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            AppSpacing.h16,
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.url,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'https://example.com/resource',
                hintStyle: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint),
                errorText: _error,
                filled: true,
                fillColor: AppColors.inputBgLight,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.medium,
                  borderSide:
                      const BorderSide(color: AppColors.dividerLight),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.medium,
                  borderSide:
                      const BorderSide(color: AppColors.dividerLight),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.medium,
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppRadius.medium,
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _confirm(),
            ),
            AppSpacing.h20,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.dividerLight),
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.medium),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                AppSpacing.w12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.medium),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Attach',
                      style: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
