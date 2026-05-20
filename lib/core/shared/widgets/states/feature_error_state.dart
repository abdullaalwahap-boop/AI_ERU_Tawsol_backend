import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';

class FeatureErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Color primaryColor;

  const FeatureErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xffDC2626).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  size: 38, color: Color(0xffDC2626)),
            ),
            AppSpacing.h20,
            Text(
              'Something Went Wrong',
              style: AppTextStyles.titleMedium.copyWith(
                color: const Color(0xff1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.h8,
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xff64748B),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.h24,
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.large,
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(
                'Try Again',
                style: AppTextStyles.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
