import 'package:flutter/material.dart';

import 'package:mp3_app/core/constants/design_tokens.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
  });

  final bool isPlaying;
  final VoidCallback onPlayPause;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        iconSize: 64,
        color: AppColors.primary,
        onPressed: onPlayPause,
        icon: Icon(
          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
        ),
      ),
    );
  }
}
