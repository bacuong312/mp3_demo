import '../types/lyric_sentence.dart';
import '../types/lyric_word.dart';

const Duration _fallbackWordDuration = Duration(milliseconds: 500);

double wordProgress(LyricSentence sentence, int wordIndex, Duration position) {
  final word = sentence.words[wordIndex];
  if (position <= word.time) return 0;

  final endTime = _wordEndTime(sentence, wordIndex);
  final totalMicroseconds = endTime.inMicroseconds - word.time.inMicroseconds;
  if (totalMicroseconds <= 0) return 1;

  final elapsedMicroseconds =
      position.inMicroseconds - word.time.inMicroseconds;
  return (elapsedMicroseconds / totalMicroseconds).clamp(0.0, 1.0);
}

Duration _wordEndTime(LyricSentence sentence, int wordIndex) {
  final words = sentence.words;
  if (wordIndex + 1 < words.length) {
    return words[wordIndex + 1].time;
  }
  return words[wordIndex].time + _averageGap(words);
}

Duration _averageGap(List<LyricWord> words) {
  if (words.length < 2) return _fallbackWordDuration;

  var totalGapMs = 0;
  for (var i = 1; i < words.length; i++) {
    totalGapMs +=
        words[i].time.inMilliseconds - words[i - 1].time.inMilliseconds;
  }
  return Duration(milliseconds: (totalGapMs / (words.length - 1)).round());
}
