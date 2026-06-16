import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class AnnounActionsButton extends StatelessWidget {
  final VoidCallback onTap;

  const AnnounActionsButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 20,
          color: context.colorTextHint,
        ),
      ),
    );
  }
}
