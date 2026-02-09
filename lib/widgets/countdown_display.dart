import 'package:flutter/material.dart';

/// A circular countdown display showing remaining time and progress.
class CountdownDisplay extends StatelessWidget {
  /// The remaining time formatted as MM:SS.
  final String timeText;

  /// Progress from 0.0 (not started) to 1.0 (complete).
  final double progress;

  /// Whether the timer is currently running.
  final bool isRunning;

  /// Whether the alarm is currently ringing.
  final bool isAlarmRinging;

  const CountdownDisplay({
    super.key,
    required this.timeText,
    required this.progress,
    required this.isRunning,
    this.isAlarmRinging = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isAlarmRinging
        ? Colors.red
        : isRunning
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle.
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              color: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          // Progress arc.
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              color: color,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Time text.
          Text(
            timeText,
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
