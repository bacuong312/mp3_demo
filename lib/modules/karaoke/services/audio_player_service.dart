import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  AudioPlayerService() : _player = AudioPlayer() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player;
  bool _hasStarted = false;

  Stream<Duration> get positionStream => _player.onPositionChanged;
  Stream<Duration> get durationStream => _player.onDurationChanged;
  Stream<PlayerState> get playerStateStream => _player.onPlayerStateChanged;
  Stream<void> get completionStream => _player.onPlayerComplete;

  bool get hasStarted => _hasStarted;

  Future<void> playFromUrl(String url) async {
    _hasStarted = true;
    await _player.play(UrlSource(url));
  }

  Future<void> resume() => _player.resume();

  Future<void> pause() => _player.pause();

  Future<void> stop() => _player.stop();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> dispose() => _player.dispose();
}
