import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/lyrics_source.dart';
import '../services/lyrics_service.dart';
import '../types/lyric_sentence.dart';

final lyricsServiceProvider = Provider<LyricsService>((ref) {
  return LyricsService();
});

final lyricsProvider = FutureProvider<List<LyricSentence>>((ref) {
  final service = ref.watch(lyricsServiceProvider);
  return service.fetchFromUrl(lyricsXmlUrl);
});
