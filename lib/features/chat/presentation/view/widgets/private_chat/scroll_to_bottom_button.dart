import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class ScrollToBottomButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onTap;

  const ScrollToBottomButton({
    super.key,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(
        ignoring: !visible,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
