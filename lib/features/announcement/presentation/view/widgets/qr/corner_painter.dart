import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/qr/corner.dart';

class CornerPainter extends CustomPainter {
  final Color color;
  final double length;
  final double strokeWidth;
  final Corner corner;

  const CornerPainter({
    required this.color,
    required this.length,
    required this.strokeWidth,
    required this.corner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (corner) {
      case Corner.topLeft:
        canvas.drawLine(Offset(0, length), const Offset(0, 0), paint);
        canvas.drawLine(const Offset(0, 0), Offset(length, 0), paint);
      case Corner.topRight:
        canvas.drawLine(
            Offset(size.width - length, 0), Offset(size.width, 0), paint);
        canvas.drawLine(
            Offset(size.width, 0), Offset(size.width, length), paint);
      case Corner.bottomLeft:
        canvas.drawLine(
            Offset(0, size.height - length), Offset(0, size.height), paint);
        canvas.drawLine(
            Offset(0, size.height), Offset(length, size.height), paint);
      case Corner.bottomRight:
        canvas.drawLine(Offset(size.width - length, size.height),
            Offset(size.width, size.height), paint);
        canvas.drawLine(Offset(size.width, size.height - length),
            Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
