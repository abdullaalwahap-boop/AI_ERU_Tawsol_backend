import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/widgets/private_chat/voice/recording_waveform.dart';

class VoiceRecordingOverlay extends StatefulWidget {
  final Stream<double> amplitudeStream;
  final VoidCallback onCancel;
  final VoidCallback onSend;

  const VoiceRecordingOverlay({
    super.key,
    required this.amplitudeStream,
    required this.onCancel,
    required this.onSend,
  });

  @override
  State<VoiceRecordingOverlay> createState() =>
      _VoiceRecordingOverlayState();
}

class _VoiceRecordingOverlayState extends State<VoiceRecordingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  Timer? _timer;
  StreamSubscription<double>? _ampSub;
  int _seconds = 0;

  // Rolling 22-entry buffer → 22 bars in the waveform.
  final List<double> _amplitudes = List.filled(22, 0.05, growable: true);

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });

    _ampSub = widget.amplitudeStream.listen((amp) {
      if (!mounted) return;
      setState(() {
        _amplitudes.removeAt(0);
        _amplitudes.add(amp);
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    _ampSub?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onCancel,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xffDC2626),
                size: 20,
              ),
            ),
          ),
          AppSpacing.w12,
          Expanded(child: RecordingWaveform(amplitudes: _amplitudes)),
          AppSpacing.w12,
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _pulseAnim.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xffDC2626),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                AppSpacing.w6,
                Text(
                  _timerText,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: context.colorTextPrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.w12,
          GestureDetector(
            onTap: widget.onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
