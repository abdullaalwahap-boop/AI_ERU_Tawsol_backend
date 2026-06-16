import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/qr/corner_borders.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const cutoutSize = 260.0;
    final cutoutTop = (size.height - cutoutSize) / 2 - 40;
    final cutoutLeft = (size.width - cutoutSize) / 2;

    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.55),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Positioned(
                top: cutoutTop,
                left: cutoutLeft,
                child: Container(
                  width: cutoutSize,
                  height: cutoutSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: cutoutTop,
          left: cutoutLeft,
          child: CornerBorders(size: cutoutSize),
        ),
      ],
    );
  }
}
