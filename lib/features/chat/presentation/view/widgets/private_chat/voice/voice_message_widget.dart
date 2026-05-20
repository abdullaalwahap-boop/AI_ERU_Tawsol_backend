import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/voice/voice_waveform.dart';

class VoiceMessageWidget extends StatefulWidget {
  final ChatMessage message;

  const VoiceMessageWidget({super.key, required this.message});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  double _progress = 0.0;
  late final AnimationController _waveController;
  late final List<double> _waveHeights;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..addListener(() {
        if (_isPlaying) setState(() {});
      });
    _waveHeights = _generateWaveform(widget.message.id, 30);
  }

  List<double> _generateWaveform(String seed, int bars) {
    final hash = seed.codeUnits.fold(0, (a, b) => a + b);
    final rng = math.Random(hash);
    return List.generate(bars, (i) {
      final base = 0.15 + rng.nextDouble() * 0.75;
      final edge = i < 3 || i > bars - 4 ? 0.4 : 1.0;
      return base * edge;
    });
  }

  void _togglePlayback() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _waveController.repeat();
      _simulateProgress();
    } else {
      _waveController.stop();
    }
  }

  void _simulateProgress() async {
    final totalSeconds =
        widget.message.voiceDuration?.inSeconds.toDouble() ?? 10;
    const tickMs = 100;
    final steps = (totalSeconds * 1000 / tickMs).round();

    for (int i = 0; i < steps; i++) {
      if (!mounted || !_isPlaying) return;
      await Future.delayed(const Duration(milliseconds: tickMs));
      if (mounted && _isPlaying) {
        setState(() => _progress = (i + 1) / steps);
      }
    }
    if (mounted) setState(() => _isPlaying = false);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isFromMe;
    final duration = widget.message.voiceDuration ?? const Duration(seconds: 0);
    final elapsed = Duration(seconds: (duration.inSeconds * _progress).round());

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlayback,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.white.withValues(alpha: 0.25)
                    : AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isMe ? Colors.white : AppColors.primary,
                size: 22,
              ),
            ),
          ),
          AppSpacing.w10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VoiceWaveform(
                  heights: _waveHeights,
                  progress: _progress,
                  isMe: isMe,
                  isPlaying: _isPlaying,
                  animation: _waveController,
                ),
                AppSpacing.h4,
                Text(
                  _isPlaying
                      ? _formatDuration(elapsed)
                      : _formatDuration(duration),
                  style: AppTextStyles.overline.copyWith(
                    color: isMe
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
