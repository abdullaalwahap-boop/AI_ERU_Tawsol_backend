import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/network/api_constants.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/data/models/chat_models.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/audio_player_service.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/voice/voice_waveform.dart';

class VoiceMessageWidget extends StatefulWidget {
  final ChatMessage message;

  const VoiceMessageWidget({super.key, required this.message});

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget>
    with SingleTickerProviderStateMixin {
  late final AudioPlayerService _playerService;
  late final AnimationController _waveController;
  late final List<double> _waveHeights;

  StreamSubscription<VoicePlaybackState>? _playSub;
  VoicePlaybackState _playback = const VoicePlaybackState();

  String get _playbackUrl {
    final url = widget.message.fileUrl;
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return ApiConstants.baseUrl + url;
  }

  @override
  void initState() {
    super.initState();

    _playerService = getIt<AudioPlayerService>();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _waveHeights = _generateWaveform(widget.message.id, 30);

    _playSub = _playerService.stateStream.listen((state) {
      if (!mounted) return;
      final isNowPlaying = state.isThisPlaying(widget.message.id);
      if (isNowPlaying && !_waveController.isAnimating) {
        _waveController.repeat();
      } else if (!isNowPlaying && _waveController.isAnimating) {
        _waveController.stop();
      }
      setState(() => _playback = state);
    });
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

  void _onTap() {
    if (_playbackUrl.isEmpty) return;
    _playerService.toggle(widget.message.id, _playbackUrl);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _playSub?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isFromMe;
    final isPlaying = _playback.isThisPlaying(widget.message.id);
    final progress = _playback.progressFor(widget.message.id);
    final uploading = widget.message.fileUrl == null;

    final displayDuration = isPlaying
        ? _playback.positionFor(widget.message.id)
        : (widget.message.voiceDuration ?? Duration.zero);

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          GestureDetector(
            onTap: uploading ? null : _onTap,
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
              child: uploading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isMe ? Colors.white : AppColors.primary,
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
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
                  progress: progress,
                  isMe: isMe,
                  isPlaying: isPlaying,
                  animation: _waveController,
                ),
                AppSpacing.h4,
                Text(
                  _formatDuration(displayDuration),
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
