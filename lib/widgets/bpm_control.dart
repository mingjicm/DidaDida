import 'package:flutter/material.dart';

class BpmControl extends StatelessWidget {
  final int bpm;
  final ValueChanged<int> onChanged;

  const BpmControl({
    super.key,
    required this.bpm,
    required this.onChanged,
  });

  void _adjust(int delta) {
    final next = (bpm + delta).clamp(20, 280);
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$bpm',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
            height: 1.1,
          ),
        ),
        const Text('BPM', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 12),
        SizedBox(
          width: 280,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            ),
            child: Slider(
              min: 20,
              max: 280,
              value: bpm.toDouble(),
              label: '$bpm BPM',
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniButton(Icons.remove, () => _adjust(-1)),
            const SizedBox(width: 24),
            _MiniButton(Icons.add, () => _adjust(1)),
          ],
        ),
      ],
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniButton(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }
}
