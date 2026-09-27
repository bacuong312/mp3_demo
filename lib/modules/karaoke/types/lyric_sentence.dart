import 'lyric_word.dart';

class LyricSentence {
  const LyricSentence({required this.words, this.singer});

  final List<LyricWord> words;
  final String? singer;

  Duration get startTime => words.isEmpty ? Duration.zero : words.first.time;

  String get text => words.map((word) => word.text).join().trim();
}
