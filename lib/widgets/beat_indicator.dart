import 'package:flutter/material.dart';

class BeatIndicator extends StatelessWidget {
  final int beatsPerMeasure;
  final int currentBeat;
  final bool accentEnabled;

  const BeatIndicator({
    super.key,
    required this.beatsPerMeasure,
    required this.currentBeat,
    this.accentEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(beatsPerMeasure, (i) {
        final isActive = i == currentBeat;
        final isAccent = i == 0 && accentEnabled;
        return _BeatDot(isActive: isActive, isAccent: isAccent, index: i);
      }),
    );
  }
}

class _BeatDot extends StatelessWidget {
  final bool isActive;
  final bool isAccent;
  final int index;

  const _BeatDot({
    required this.isActive,
    required this.isAccent,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = isActive ? 20.0 : 14.0;
    final color = isActive
        ? (isAccent ? Colors.orange : theme.colorScheme.primary)
        : theme.colorScheme.onSurface.withValues(alpha: 0.2);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 80),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
