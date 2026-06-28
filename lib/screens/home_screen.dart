import 'package:flutter/material.dart';
import '../engines/metronome_engine.dart';
import '../data/presets.dart';
import '../widgets/beat_indicator.dart';
import '../widgets/bpm_control.dart';
import '../widgets/transport_controls.dart';
import '../widgets/time_signature_picker.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final MetronomeEngine engine;

  const HomeScreen({super.key, required this.engine});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bpm = 120;
  int _beatsPerMeasure = 4;
  int _beatUnit = 4;
  int _currentBeat = 0;
  int _totalBeats = 0;
  int _remainingSeconds = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  final bool _accentEnabled = true;
  String? _activePreset;
  int? _timerMinutes;

  @override
  void initState() {
    super.initState();
    final e = widget.engine;
    e.bpm = _bpm;
    e.beatsPerMeasure = _beatsPerMeasure;
    e.beatUnit = _beatUnit;
    e.accentEnabled = _accentEnabled;

    e.onBeat = (beat, isAccent, total) {
      if (mounted) {
        setState(() {
          _currentBeat = beat;
          _totalBeats = total;
        });
      }
    };

    e.onTimerTick = (secs) {
      if (mounted) setState(() => _remainingSeconds = secs);
    };

    e.onPlayStateChanged = () {
      if (mounted) {
        setState(() {
          _isPlaying = e.isPlaying;
          _isPaused = e.isPaused;
        });
      }
    };

    e.onTimerComplete = () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('练习结束！'), duration: Duration(seconds: 2)),
        );
      }
    };
  }

  void _applyPreset(RhythmPreset p) {
    setState(() {
      _bpm = p.bpm;
      _beatsPerMeasure = p.beatsPerMeasure;
      _beatUnit = p.beatUnit;
      _activePreset = p.name;
    });
    final e = widget.engine;
    e.bpm = _bpm;
    e.beatsPerMeasure = _beatsPerMeasure;
    e.beatUnit = _beatUnit;
  }

  void _updateBpm(int v) {
    setState(() {
      _bpm = v;
      _activePreset = null;
    });
    widget.engine.bpm = v;
  }

  void _updateBeats(int v) {
    setState(() => _beatsPerMeasure = v);
    widget.engine.beatsPerMeasure = v;
  }

  void _updateBeatUnit(int v) {
    setState(() => _beatUnit = v);
    widget.engine.beatUnit = v;
  }

  String _formatTime(int secs) {
    if (secs <= 0) return '--:--';
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showPresetDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('节奏预设', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      children: [
                        _presetSection('架子鼓', '架子鼓', ctx),
                        const SizedBox(height: 12),
                        _presetSection('尤克里里', '尤克里里', ctx),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _presetSection(String title, String category, BuildContext ctx) {
    final items = presetsByCategory(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        ...items.map((p) => Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            dense: true,
            title: Text(p.name),
            subtitle: Text(p.description, style: const TextStyle(fontSize: 12)),
            trailing: _activePreset == p.name
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              _applyPreset(p);
              Navigator.pop(ctx);
            },
          ),
        )),
      ],
    );
  }

  void _showTimerPicker() {
    final options = [0, 1, 5, 10, 15, 30];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('练习计时', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text('选择时长，倒计时结束后自动停止', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((min) {
                    final isActive = _timerMinutes == min;
                    final label = min == 0 ? '关闭' : '$min 分钟';
                    return ChoiceChip(
                      label: Text(label),
                      selected: isActive,
                      onSelected: (_) {
                        setState(() {
                          _timerMinutes = min;
                          widget.engine.timerEnabled = min > 0;
                          widget.engine.timerDurationMinutes = min;
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      _timerMinutes != null && _timerMinutes! > 0
                          ? Icons.timer
                          : Icons.timer_outlined,
                      color: _timerMinutes != null && _timerMinutes! > 0
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    onPressed: _showTimerPicker,
                  ),
                  Text(
                    _remainingSeconds > 0
                        ? _formatTime(_remainingSeconds)
                        : '$_totalBeats 拍',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(engine: widget.engine),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Beat indicator
            BeatIndicator(
              beatsPerMeasure: _beatsPerMeasure,
              currentBeat: _isPlaying ? _currentBeat : -1,
              accentEnabled: _accentEnabled,
            ),

            const SizedBox(height: 32),

            // BPM control
            BpmControl(bpm: _bpm, onChanged: _updateBpm),

            const SizedBox(height: 32),

            // Transport controls
            TransportControls(
              isPlaying: _isPlaying,
              isPaused: _isPaused,
              onPlay: () => widget.engine.play(),
              onPause: () => widget.engine.pause(),
              onResume: () => widget.engine.resume(),
              onStop: () => widget.engine.stop(),
            ),

            const Spacer(),

            // Bottom bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TimeSignaturePicker(
                    beatsPerMeasure: _beatsPerMeasure,
                    beatUnit: _beatUnit,
                    onBeatsChanged: _updateBeats,
                    onUnitChanged: _updateBeatUnit,
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.library_music_outlined, size: 18),
                    label: Text(_activePreset ?? '预设', style: const TextStyle(fontSize: 13)),
                    onPressed: _showPresetDialog,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.engine.onBeat = null;
    widget.engine.onTimerTick = null;
    widget.engine.onPlayStateChanged = null;
    widget.engine.onTimerComplete = null;
    super.dispose();
  }
}
