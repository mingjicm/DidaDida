import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BpmControl extends StatefulWidget {
  final int bpm;
  final ValueChanged<int> onChanged;
  final String? activePreset;

  const BpmControl({
    super.key,
    required this.bpm,
    required this.onChanged,
    this.activePreset,
  });

  @override
  State<BpmControl> createState() => _BpmControlState();
}

class _BpmControlState extends State<BpmControl> {
  final List<int> _quickBpms = [40, 60, 72, 80, 90, 100, 110, 120, 140, 160, 180, 200];

  // Tap tempo
  final List<DateTime> _tapTimes = [];
  Timer? _tapResetTimer;

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    super.dispose();
  }

  void _adjust(int delta) {
    final next = (widget.bpm + delta).clamp(20, 280);
    widget.onChanged(next);
  }

  void _onTapBpm() {
    final now = DateTime.now();
    _tapTimes.add(now);

    // Keep only last 5 taps in 3 seconds
    _tapTimes.removeWhere((t) => now.difference(t) > const Duration(seconds: 3));
    if (_tapTimes.length > 5) {
      _tapTimes.removeAt(0);
    }

    if (_tapTimes.length >= 2) {
      final intervals = <double>[];
      for (int i = 1; i < _tapTimes.length; i++) {
        intervals.add(_tapTimes[i].difference(_tapTimes[i - 1]).inMilliseconds.toDouble());
      }
      final avg = intervals.reduce((a, b) => a + b) / intervals.length;
      if (avg > 0) {
        final bpm = (60000 / avg).round().clamp(20, 280);
        widget.onChanged(bpm);
      }
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Auto-reset after 2s of no taps
    _tapResetTimer?.cancel();
    _tapResetTimer = Timer(const Duration(seconds: 2), () {
      _tapTimes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // BPM number
        Text(
          '${widget.bpm}',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.primary,
            height: 1.1,
          ),
        ),
        const Text('BPM', style: TextStyle(fontSize: 14, color: Colors.grey)),

        // Preset hint
        if (widget.activePreset != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.activePreset!,
              style: TextStyle(fontSize: 12, color: theme.colorScheme.primary.withValues(alpha: 0.6)),
            ),
          ),

        const SizedBox(height: 8),

        // BPM Slider
        SizedBox(
          width: 280,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              thumbColor: theme.colorScheme.primary,
              overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Slider(
              min: 20,
              max: 280,
              value: widget.bpm.toDouble(),
              label: '${widget.bpm} BPM',
              onChanged: (v) => widget.onChanged(v.round()),
            ),
          ),
        ),

        // Quick BPM chips
        const SizedBox(height: 4),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _quickBpms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (ctx, i) {
              final v = _quickBpms[i];
              final isActive = widget.bpm == v;
              return GestureDetector(
                onTap: () => widget.onChanged(v),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary.withValues(alpha: 0.15)
                        : Colors.grey.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive
                          ? theme.colorScheme.primary.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    '$v',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                      color: isActive ? theme.colorScheme.primary : Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Minus / Tap / Plus
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniButton(Icons.remove, () => _adjust(-1)),
            const SizedBox(width: 12),
            // Tap Tempo button
            _TapButton(onTap: _onTapBpm),
            const SizedBox(width: 12),
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

class _TapButton extends StatefulWidget {
  final VoidCallback onTap;
  const _TapButton({required this.onTap});

  @override
  State<_TapButton> createState() => _TapButtonState();
}

class _TapButtonState extends State<_TapButton> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        _animCtrl.forward().then((_) => _animCtrl.reverse());
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.85).animate(_animCtrl),
        child: Container(
          width: 56,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app, size: 16, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text('Tap', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
