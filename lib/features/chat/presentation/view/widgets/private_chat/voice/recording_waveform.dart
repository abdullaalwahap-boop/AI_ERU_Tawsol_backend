import 'package:flutter/material.dart';

/// Displays a rolling history of amplitude values as animated vertical bars.
/// Each bar uses [AnimatedContainer] so height transitions are smooth.
class RecordingWaveform extends StatelessWidget {
  /// Normalised amplitude values — each entry in [0.0, 1.0].
  /// Length determines bar count; the widget fills available width evenly.
  final List<double> amplitudes;

  const RecordingWaveform({super.key, required this.amplitudes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: amplitudes.map((amp) {
          final h = (amp * 24 + 4).clamp(4.0, 28.0);
          return AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: 3,
            height: h,
            decoration: BoxDecoration(
              color: Color.lerp(
                const Color(0xffDC2626).withValues(alpha: 0.45),
                const Color(0xffDC2626),
                amp,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }).toList(),
      ),
    );
  }
}
