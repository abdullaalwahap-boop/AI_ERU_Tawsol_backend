import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/recorder_result.dart';

export 'recorder_result.dart';

/// Wraps the [record] package — one recording session at a time.
/// Registered as a GetIt singleton so only one recorder exists app-wide.
class VoiceRecorderService {
  final _recorder = AudioRecorder();

  DateTime? _startTime;
  String? _currentPath;
  Timer? _ampTimer;

  final _amplitudeController = StreamController<double>.broadcast();

  /// Normalized amplitude stream: 0.0 (silent) → 1.0 (loudest), 100 ms ticks.
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  // ── Permission ─────────────────────────────────────────────────────────────

  Future<PermissionStatus> checkPermission() => Permission.microphone.status;

  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> isPermanentlyDenied() async {
    final status = await Permission.microphone.status;
    return status.isPermanentlyDenied;
  }

  // ── Recording lifecycle ────────────────────────────────────────────────────

  /// Starts recording to a temp .m4a file.
  /// Returns false if permission is missing or the recorder fails to start.
  Future<bool> startRecording() async {
    if (await _recorder.isRecording()) return false;
    if (!await _recorder.hasPermission()) return false;

    final dir = await getTemporaryDirectory();
    _currentPath =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _startTime = DateTime.now();

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: _currentPath!,
    );

    // Poll getAmplitude() instead of using onAmplitudeChanged() — the stream
    // returned by onAmplitudeChanged is single-subscription on some platforms
    // and throws "already listened to" on the second recording session.
    _ampTimer?.cancel();
    _ampTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      try {
        final amp = await _recorder.getAmplitude();
        final normalised = ((amp.current + 160) / 160).clamp(0.0, 1.0);
        if (!_amplitudeController.isClosed) {
          _amplitudeController.add(normalised);
        }
      } catch (_) {}
    });

    return true;
  }

  /// Stops recording and returns the file path + duration.
  /// Returns null if nothing was recorded.
  Future<RecorderResult?> stopRecording() async {
    _ampTimer?.cancel();
    _ampTimer = null;

    final path = await _recorder.stop();
    final duration = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;
    _startTime = null;
    _currentPath = null;

    if (path == null) return null;
    return RecorderResult(filePath: path, durationSeconds: duration);
  }

  /// Cancels recording without saving — deletes the temp file.
  Future<void> cancelRecording() async {
    _ampTimer?.cancel();
    _ampTimer = null;

    final path = await _recorder.stop();
    _startTime = null;
    _currentPath = null;

    if (path != null) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }

  Future<bool> isRecording() => _recorder.isRecording();

  void dispose() {
    _ampTimer?.cancel();
    if (!_amplitudeController.isClosed) _amplitudeController.close();
    _recorder.dispose();
  }
}
