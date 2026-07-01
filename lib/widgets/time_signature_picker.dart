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

  // Common time signatures grouped
  static const List<Map<String, dynamic>> _commonSignatures = [
    {'beats': 2, 'unit': 4, 'label': '2/4', 'desc': '进行曲'},
    {'beats': 3, 'unit': 4, 'label': '3/4', 'desc': '华尔兹'},
    {'beats': 4, 'unit': 4, 'label': '4/4', 'desc': '通用'},
    {'beats': 5, 'unit': 4, 'label': '5/4', 'desc': '混合拍'},
    {'beats': 6, 'unit': 8, 'label': '6/8', 'desc': '摇摆'},
    {'beats': 7, 'unit': 8, 'label': '7/8', 'desc': '混合拍'},
    {'beats': 9, 'unit': 8, 'label': '9/8', 'desc': '复拍子'},
    {'beats': 12, 'unit': 8, 'label': '12/8', 'desc': '复拍子'},
    {'beats': 8, 'unit': 8, 'label': '8/8', 'desc': '混合拍'},
    {'beats': 10, 'unit': 8, 'label': '10/8', 'desc': '混合拍'},
    {'beats': 11, 'unit': 8, 'label': '11/8', 'desc': '混合拍'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLabel = '$beatsPerMeasure/$beatUnit';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.music_note, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text('拍号', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 6),
          // Quick select chips
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: _commonSignatures.length,
              separatorBuilder: (_, __) => const SizedBox(width: 4),
              itemBuilder: (ctx, i) {
                final sig = _commonSignatures[i];
                final label = sig['label'] as String;
                final isActive = label == currentLabel;
                return GestureDetector(
                  onTap: () {
                    onBeatsChanged(sig['beats'] as int);
                    onUnitChanged(sig['unit'] as int);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? theme.colorScheme.primary.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                            color: isActive ? theme.colorScheme.primary : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
