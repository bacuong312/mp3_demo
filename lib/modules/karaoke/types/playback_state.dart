class PlaybackState {
  const PlaybackState({
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
  });

  final Duration position;
  final Duration duration;
  final bool isPlaying;

  PlaybackState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
  }) {
    return PlaybackState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
