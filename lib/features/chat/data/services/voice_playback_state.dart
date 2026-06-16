class VoicePlaybackState {
  final String? playingId;
  final bool isPlaying;
  final Duration position;
  final Duration total;

  const VoicePlaybackState({
    this.playingId,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.total = Duration.zero,
  });

  bool isThisPlaying(String id) => playingId == id && isPlaying;

  double progressFor(String id) {
    if (playingId != id || total.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
  }

  Duration positionFor(String id) =>
      playingId == id ? position : Duration.zero;
}
