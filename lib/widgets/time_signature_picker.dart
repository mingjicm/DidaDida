import 'package:flutter/material.dart';

class TimeSignaturePicker extends StatelessWidget {
  final int beatsPerMeasure;
  final int beatUnit;
  final ValueChanged<int> onBeatsChanged;
  final ValueChanged<int> onUnitChanged;

  const TimeSignaturePicker({
    super.key,
    required this.beatsPerMeasure,
    required this.beatUnit,
    required this.onBeatsChanged,
    required this.onUnitChanged,
  });

  static const List<int> _beatOptions = [2, 3, 4, 5, 6, 7, 9, 12];
  static const List<int> _unitOptions = [2, 4, 8];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.music_note, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('拍号', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          const SizedBox(width: 8),
          _Dropdown(
            value: beatsPerMeasure,
            items: _beatOptions,
            onChanged: onBeatsChanged,
          ),
          const Text(' / ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          _Dropdown(
            value: beatUnit,
            items: _unitOptions,
            onChanged: onUnitChanged,
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final int value;
  final List<int> items;
  final ValueChanged<int> onChanged;

  const _Dropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          items: items.map((v) {
            return DropdownMenuItem(value: v, child: Text('$v'));
          }).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
