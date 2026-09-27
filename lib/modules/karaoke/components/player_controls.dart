import 'package:flutter/material.dart';

import 'package:mp3_app/core/constants/design_tokens.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onStop,
  });

  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 40,
          color: AppColors.textPrimary,
          onPressed: onStop,
          icon: const Icon(Icons.stop),
        ),
        const SizedBox(width: 24),
        IconButton(
          iconSize: 64,
          color: AppColors.primary,
          onPressed: onPlayPause,
          icon: Icon(
            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
          ),
        ),
      ],
    );
  }
}
