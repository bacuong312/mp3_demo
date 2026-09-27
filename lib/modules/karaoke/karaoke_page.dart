import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mp3_app/core/constants/design_tokens.dart';
import 'package:mp3_app/widgets/ui/seek_bar/seek_bar.dart';

import './components/lyrics_view.dart';
import './components/player_controls.dart';
import './providers/lyrics_provider.dart';
import './providers/playback_provider.dart';
import './types/lyric_sentence.dart';
import './utils/duration_format_utils.dart';
import './utils/lyrics_xml_utils.dart';

class KaraokePage extends ConsumerWidget {
  const KaraokePage({super.key});

  Widget _buildLyrics(WidgetRef ref, Duration position) {
    final lyricsAsync = ref.watch(lyricsProvider);

    return lyricsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Failed to load lyrics',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.invalidate(lyricsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (sentences) => _buildLyricsView(sentences, position),
    );
  }

  Widget _buildLyricsView(List<LyricSentence> sentences, Duration position) {
    final activeSentenceIndex = findActiveSentenceIndex(sentences, position);

    return LyricsView(
      sentences: sentences,
      activeSentenceIndex: activeSentenceIndex,
      position: position,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(playbackProvider);
    final playbackNotifier = ref.read(playbackProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Karaoke Demo')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildLyrics(ref, playback.position)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(playback.position)),
                  Text(formatDuration(playback.duration)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SeekBar(
                position: playback.position,
                duration: playback.duration,
                onSeek: playbackNotifier.seek,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: PlayerControls(
                isPlaying: playback.isPlaying,
                onPlayPause: playbackNotifier.togglePlayPause,
                onStop: playbackNotifier.stop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
