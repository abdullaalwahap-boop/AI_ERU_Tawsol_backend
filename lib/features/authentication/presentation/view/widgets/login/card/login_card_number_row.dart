import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class LoginCardNumberRow extends StatelessWidget {
  const LoginCardNumberRow({
    super.key,
    required this.dotSize,
    required this.cardWidth,
  });

  final double dotSize;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final dotSpacing = dotSize * 0.7;
    final groupSpacing = cardWidth * 0.022;
    final fontSize = (cardWidth * 0.04).clamp(9.0, 13.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DotGroup(dotSize: dotSize, dotSpacing: dotSpacing),
        SizedBox(width: groupSpacing),
        _DotGroup(dotSize: dotSize, dotSpacing: dotSpacing),
        SizedBox(width: groupSpacing),
        _DotGroup(dotSize: dotSize, dotSpacing: dotSpacing),
        SizedBox(width: groupSpacing + dotSize),
        Text(
          'ERU',
          style: AppTextStyles.titleSmall.copyWith(
            color: Colors.white70,
            fontSize: fontSize,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _DotGroup extends StatelessWidget {
  const _DotGroup({required this.dotSize, required this.dotSpacing});

  final double dotSize;
  final double dotSpacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        4,
        (i) => Padding(
          padding: EdgeInsets.only(right: i < 3 ? dotSpacing : 0),
          child: Container(
            width: dotSize,
            height: dotSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white38,
            ),
          ),
        ),
      ),
    );
  }
}
