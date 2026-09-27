import 'package:flutter/material.dart';

import 'package:mp3_app/core/constants/design_tokens.dart';

class SeekBar extends StatelessWidget {
  const SeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  @override
  Widget build(BuildContext context) {
    final totalMs = duration.inMilliseconds;
    final maxMs = totalMs == 0 ? 1.0 : totalMs.toDouble();
    final value = position.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.divider,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.2),
      ),
      child: Slider(
        min: 0,
        max: maxMs,
        value: value,
        onChanged: (newValue) {
          onSeek(Duration(milliseconds: newValue.round()));
        },
      ),
    );
  }
}
