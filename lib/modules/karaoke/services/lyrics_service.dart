import 'dart:convert';

import 'package:http/http.dart' as http;

import '../types/lyric_sentence.dart';
import '../utils/lyrics_xml_utils.dart';

class LyricsService {
  Future<List<LyricSentence>> fetchFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load lyrics (${response.statusCode})');
    }

    return parseLyricsXml(utf8.decode(response.bodyBytes));
  }
}
