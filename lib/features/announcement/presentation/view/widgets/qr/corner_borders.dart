import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/qr/corner.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/qr/corner_painter.dart';

class CornerBorders extends StatelessWidget {
  final double size;

  const CornerBorders({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    const cornerLength = 28.0;
    const cornerWidth = 4.0;
    const color = AppColors.accent;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: CustomPaint(
              painter: CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: Corner.topLeft,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              painter: CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: Corner.topRight,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              painter: CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: Corner.bottomLeft,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomPaint(
              painter: CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: Corner.bottomRight,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
        ],
      ),
    );
  }
}
