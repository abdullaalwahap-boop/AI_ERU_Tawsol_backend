import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

class QrScannerView extends StatefulWidget {
  const QrScannerView({super.key});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    _scanned = true;
    _controller.stop();

    final result = barcode.rawValue!;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context).scanQrCode),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, __) {
                switch (state.torchState) {
                  case TorchState.on:
                    return const Icon(Icons.flash_on_rounded, color: Colors.amber);
                  case TorchState.off:
                  default:
                    return const Icon(Icons.flash_off_rounded, color: Colors.white);
                }
              },
            ),
            onPressed: _controller.toggleTorch,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          _ScannerOverlay(),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                AppLocalizations.of(context).alignQrCode,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
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
          child: _CornerBorders(size: cutoutSize),
        ),
      ],
    );
  }
}

class _CornerBorders extends StatelessWidget {
  final double size;

  const _CornerBorders({required this.size});

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
          // Top-left
          Positioned(
            top: 0,
            left: 0,
            child: CustomPaint(
              painter: _CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: _Corner.topLeft,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          // Top-right
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              painter: _CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: _Corner.topRight,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          // Bottom-left
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomPaint(
              painter: _CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: _Corner.bottomLeft,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
          // Bottom-right
          Positioned(
            bottom: 0,
            right: 0,
            child: CustomPaint(
              painter: _CornerPainter(
                color: color,
                length: cornerLength,
                strokeWidth: cornerWidth,
                corner: _Corner.bottomRight,
              ),
              size: const Size(cornerLength, cornerLength),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerPainter extends CustomPainter {
  final Color color;
  final double length;
  final double strokeWidth;
  final _Corner corner;

  const _CornerPainter({
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
      case _Corner.topLeft:
        canvas.drawLine(Offset(0, length), const Offset(0, 0), paint);
        canvas.drawLine(const Offset(0, 0), Offset(length, 0), paint);
      case _Corner.topRight:
        canvas.drawLine(Offset(size.width - length, 0), Offset(size.width, 0), paint);
        canvas.drawLine(Offset(size.width, 0), Offset(size.width, length), paint);
      case _Corner.bottomLeft:
        canvas.drawLine(Offset(0, size.height - length), Offset(0, size.height), paint);
        canvas.drawLine(Offset(0, size.height), Offset(length, size.height), paint);
      case _Corner.bottomRight:
        canvas.drawLine(
            Offset(size.width - length, size.height), Offset(size.width, size.height), paint);
        canvas.drawLine(
            Offset(size.width, size.height - length), Offset(size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
