import 'package:flutter/material.dart';

import 'package:mp3_app/core/constants/design_tokens.dart';

import '../types/lyric_sentence.dart';
import '../utils/lyrics_progress_utils.dart';

class LyricsView extends StatefulWidget {
  const LyricsView({
    super.key,
    required this.sentences,
    required this.activeSentenceIndex,
    required this.position,
  });

  final List<LyricSentence> sentences;
  final int activeSentenceIndex;
  final Duration position;

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  static const double _lineHeight = 68;

  final ScrollController _controller = ScrollController();

  @override
  void didUpdateWidget(LyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeSentenceIndex != widget.activeSentenceIndex) {
      _scrollToActive();
    }
  }

  void _scrollToActive() {
    if (!_controller.hasClients || widget.activeSentenceIndex < 0) return;
    final target = (widget.activeSentenceIndex * _lineHeight) - 80;
    _controller.animateTo(
      target.clamp(0, _controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InlineSpan _buildWordSpan(LyricSentence sentence, int index) {
    final progress = wordProgress(sentence, index, widget.position);

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: const [
              AppColors.primary,
              AppColors.primary,
              AppColors.lyricInactive,
              AppColors.lyricInactive,
            ],
            stops: [0, progress, progress, 1],
          ).createShader(bounds);
        },
        child: Text(
          sentence.words[index].text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildActiveLine(LyricSentence sentence) {
    return Text.rich(
      TextSpan(
        children: List<InlineSpan>.generate(
          sentence.words.length,
          (index) => _buildWordSpan(sentence, index),
        ),
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInactiveLine(LyricSentence sentence) {
    return Text(
      sentence.text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16, color: AppColors.lyricInactive),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.symmetric(vertical: 120),
      itemCount: widget.sentences.length,
      itemBuilder: (context, index) {
        final sentence = widget.sentences[index];
        final isActive = index == widget.activeSentenceIndex;

        return Container(
          height: _lineHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: isActive
              ? _buildActiveLine(sentence)
              : _buildInactiveLine(sentence),
        );
      },
    );
  }
}
