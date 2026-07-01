import 'package:flutter/material.dart';
import '../engines/metronome_engine.dart';
import '../models/metronome_state.dart';

class SettingsScreen extends StatefulWidget {
  final MetronomeEngine engine;

  const SettingsScreen({super.key, required this.engine});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _volume = 0.8;
  bool _vibrate = false;
  bool _keepScreenOn = true;
  bool _accentEnabled = true;
  SoundScheme _soundScheme = SoundScheme.classic;

  @override
  void initState() {
    super.initState();
    final e = widget.engine;
    _volume = e.volume;
    _vibrate = e.vibrateEnabled;
    _keepScreenOn = true;
    _accentEnabled = e.accentEnabled;
    _soundScheme = e.soundScheme;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            children: [
              Row(
                children: [
                  const Icon(Icons.volume_up_outlined, size: 20),
                  const SizedBox(width: 8),
                  const Text('音量', style: TextStyle(fontSize: 15)),
                  const Spacer(),
                  Text('${(_volume * 100).round()}%',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: theme.colorScheme.primary,
                  inactiveTrackColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                  thumbColor: theme.colorScheme.primary,
                  overlayColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Slider(
                  min: 0,
                  max: 1,
                  value: _volume,
                  onChanged: (v) {
                    setState(() => _volume = v);
                    widget.engine.setVolume(v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('重拍提示', style: TextStyle(fontSize: 15)),
                subtitle: const Text('每小节第一拍使用不同音色', style: TextStyle(fontSize: 12, color: Colors.grey)),
                value: _accentEnabled,
                onChanged: (v) {
                  setState(() => _accentEnabled = v);
                  widget.engine.accentEnabled = v;
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('振动反馈', style: TextStyle(fontSize: 15)),
                subtitle: const Text('每拍时 iPhone 轻微振动', style: TextStyle(fontSize: 12, color: Colors.grey)),
                value: _vibrate,
                onChanged: (v) {
                  setState(() => _vibrate = v);
                  widget.engine.vibrateEnabled = v;
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.music_note_outlined, size: 20),
                    SizedBox(width: 8),
                    Text('声音方案', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              Wrap(
                spacing: 8,
                children: SoundScheme.values.map((s) {
                  final label = switch (s) {
                    SoundScheme.classic => '经典滴答',
                    SoundScheme.wood => '木鱼声',
                    SoundScheme.electronic => '电子音',
                    SoundScheme.drumKit => '架子鼓',
                  };
                  final isSelected = _soundScheme == s;
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (v) {
                      if (v) {
                        setState(() => _soundScheme = s);
                        widget.engine.soundScheme = s;
                        widget.engine.reloadSounds();
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('屏幕常亮', style: TextStyle(fontSize: 15)),
                subtitle: const Text('练习时不自动熄屏', style: TextStyle(fontSize: 12, color: Colors.grey)),
                value: _keepScreenOn,
                onChanged: (v) {
                  setState(() => _keepScreenOn = v);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text('节拍器 v1.0', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                const SizedBox(height: 4),
                Text('给架子鼓和尤克里里练习用', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;

  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }
}
