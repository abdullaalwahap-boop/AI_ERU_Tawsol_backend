import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';

class AnnounCardPreview extends StatelessWidget {
  final String body;

  const AnnounCardPreview({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final preview =
        body.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    return Text(
      preview,
      style: AppTextStyles.labelMedium.copyWith(
        fontSize: 12.5,
        color: context.colorTextSecondary,
        height: 1.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
