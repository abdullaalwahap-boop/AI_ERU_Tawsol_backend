import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ai_eru_tawasol/features/chat/data/services/voice_playback_state.dart';

export 'voice_playback_state.dart';

/// Global singleton: ensures only one voice message plays at a time.
/// Registered with GetIt so all [VoiceMessageWidget]s share one player.
class AudioPlayerService {
  final _player = AudioPlayer();
  String? _currentId;

  final _stateController = StreamController<VoicePlaybackState>.broadcast();
  Stream<VoicePlaybackState> get stateStream => _stateController.stream;

  StreamSubscription? _positionSub;
  StreamSubscription? _playerStateSub;
  StreamSubscription? _durationSub;
  Duration _duration = Duration.zero;

  AudioPlayerService() {
    _configureAudioSession();
    _positionSub = _player.positionStream.listen((_) => _emit());
    _durationSub = _player.durationStream.listen((d) {
      _duration = d ?? Duration.zero;
      _emit();
    });
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _currentId = null;
        _duration = Duration.zero;
        _player.stop();
      }
      _emit();
    });
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
    ));
  }

  void _emit() {
    if (_stateController.isClosed) return;
    _stateController.add(VoicePlaybackState(
      playingId: _currentId,
      isPlaying: _player.playing,
      position: _player.position,
      total: _duration,
    ));
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Toggle play/pause for [id] at [url].
  /// Stops any other currently-playing message automatically.
  Future<void> toggle(String id, String url) async {
    try {
      if (_currentId == id) {
        _player.playing ? await _player.pause() : await _player.play();
        return;
      }

      // Switch to a different message.
      await _player.stop();
      _currentId = id;
      _duration = Duration.zero;
      _emit();

      if (url.startsWith('/') || url.startsWith('file://')) {
        await _player.setFilePath(
            url.startsWith('file://') ? url.substring(7) : url);
      } else {
        await _player.setUrl(url);
      }

      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      _currentId = null;
      _emit();
    }
  }

  /// Seek within the currently-playing message.
  Future<void> seek(String id, Duration position) async {
    if (_currentId != id) return;
    await _player.seek(position);
    _emit();
  }

  /// Stop playback of [id] if it is the active one.
  void stopIfPlaying(String id) {
    if (_currentId != id) return;
    _player.stop();
    _currentId = null;
    _emit();
  }

  void stopAll() {
    _player.stop();
    _currentId = null;
    _emit();
  }

  void dispose() {
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _durationSub?.cancel();
    _player.dispose();
    if (!_stateController.isClosed) _stateController.close();
  }
}
