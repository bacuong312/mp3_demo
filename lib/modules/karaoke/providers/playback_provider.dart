import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/demo_track.dart';
import '../services/audio_player_service.dart';
import '../types/playback_state.dart';

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

final playbackProvider = NotifierProvider<PlaybackNotifier, PlaybackState>(
  PlaybackNotifier.new,
);

class PlaybackNotifier extends Notifier<PlaybackState> {
  late AudioPlayerService _service;

  @override
  PlaybackState build() {
    _service = ref.watch(audioPlayerServiceProvider);

    final positionSubscription = _service.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });
    final durationSubscription = _service.durationStream.listen((duration) {
      state = state.copyWith(duration: duration);
    });
    final playerStateSubscription = _service.playerStateStream.listen((
      playerState,
    ) {
      state = state.copyWith(isPlaying: playerState == PlayerState.playing);
    });
    final completionSubscription = _service.completionStream.listen((_) {
      state = state.copyWith(isPlaying: false, position: Duration.zero);
    });

    ref.onDispose(() {
      positionSubscription.cancel();
      durationSubscription.cancel();
      playerStateSubscription.cancel();
      completionSubscription.cancel();
    });

    return const PlaybackState();
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await _service.pause();
      return;
    }
    if (_service.hasStarted) {
      await _service.resume();
      return;
    }
    await _service.playFromUrl(demoTrackUrl);
  }

  Future<void> stop() async {
    await _service.stop();
    state = state.copyWith(position: Duration.zero);
  }

  Future<void> seek(Duration position) async {
    await _service.seek(position);
    state = state.copyWith(position: position);
  }
}
