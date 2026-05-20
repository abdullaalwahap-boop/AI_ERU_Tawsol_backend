import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class VoiceWaveform extends StatelessWidget {
  final List<double> heights;
  final double progress;
  final bool isMe;
  final bool isPlaying;
  final Animation<double> animation;

  const VoiceWaveform({
    super.key,
    required this.heights,
    required this.progress,
    required this.isMe,
    required this.isPlaying,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return SizedBox(
          height: 28,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(heights.length, (i) {
              final isPlayed = i / heights.length < progress;
              double h = heights[i] * 28;

              if (isPlaying) {
                final currentBar = (progress * heights.length).floor();
                if (i == currentBar) {
                  final wave = math.sin(animation.value * 2 * math.pi);
                  h = h * (0.7 + 0.3 * wave.abs());
                }
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 60),
                width: 2.5,
                height: h.clamp(4.0, 28.0),
                decoration: BoxDecoration(
                  color: isMe
                      ? (isPlayed
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4))
                      : (isPlayed
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
