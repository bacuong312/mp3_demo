String formatDuration(Duration duration) {
  final totalSeconds = duration.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  final secondsLabel = seconds.toString().padLeft(2, '0');
  return '$minutes:$secondsLabel';
}
