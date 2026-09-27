import 'package:xml/xml.dart';

import '../types/lyric_sentence.dart';
import '../types/lyric_word.dart';

List<LyricSentence> parseLyricsXml(String xmlSource) {
  final document = XmlDocument.parse(xmlSource);
  final sentences = <LyricSentence>[];

  for (final paramElement in document.findAllElements('param')) {
    final words = <LyricWord>[];

    for (final wordElement in paramElement.findElements('i')) {
      final seconds = double.tryParse(wordElement.getAttribute('va') ?? '');
      if (seconds == null) continue;

      words.add(
        LyricWord(
          time: Duration(milliseconds: (seconds * 1000).round()),
          text: wordElement.innerText,
        ),
      );
    }

    if (words.isNotEmpty) {
      sentences.add(
        LyricSentence(words: words, singer: paramElement.getAttribute('s')),
      );
    }
  }

  return sentences;
}

int findActiveSentenceIndex(List<LyricSentence> sentences, Duration position) {
  var activeIndex = -1;
  for (var i = 0; i < sentences.length; i++) {
    if (sentences[i].startTime <= position) {
      activeIndex = i;
    } else {
      break;
    }
  }
  return activeIndex;
}

