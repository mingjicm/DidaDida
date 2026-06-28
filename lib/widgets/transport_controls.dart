import 'package:flutter/material.dart';

class TransportControls extends StatelessWidget {
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onStop;

  const TransportControls({
    super.key,
    required this.isPlaying,
    required this.isPaused,
    required this.onPlay,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TransportButton(
          icon: Icons.stop_rounded,
          onTap: isPlaying ? onStop : null,
          size: 48,
          color: Colors.grey,
        ),
        const SizedBox(width: 32),
        _TransportButton(
          icon: isPlaying && !isPaused ? Icons.pause_rounded : Icons.play_arrow_rounded,
          onTap: () {
            if (isPlaying && isPaused) {
              onResume();
            } else if (isPlaying) {
              onPause();
            } else {
              onPlay();
            }
          },
          size: 64,
          color: theme.colorScheme.primary,
          isMain: true,
        ),
        const SizedBox(width: 32),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _TransportButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final bool isMain;

  const _TransportButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.color,
    this.isMain = false,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = onTap == null ? 0.3 : 1.0;
    final diameter = isMain ? 72.0 : 48.0;

    return Opacity(
      opacity: opacity,
      child: Material(
        color: isMain ? color.withValues(alpha: 0.1) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(diameter / 2),
          side: isMain
              ? BorderSide.none
              : BorderSide(color: color.withValues(alpha: opacity * 0.4)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(diameter / 2),
          onTap: onTap,
          child: Container(
            width: diameter,
            height: diameter,
            alignment: Alignment.center,
            child: Icon(icon, size: size / 2, color: color.withValues(alpha: opacity)),
          ),
        ),
      ),
    );
  }
}
