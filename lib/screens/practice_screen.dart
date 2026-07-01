import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _currentTab = 0;
  int _score = 0;
  int _round = 0;
  String _message = '';
  String _currentPattern = '';
  List<int> _userPattern = [];

  final List<String> _easyPatterns = ['X', 'X·X', 'XX·X', 'X·XX', 'XXX·'];
  final List<String> _hardPatterns = ['X·X·X', 'X·XX·X', 'XX·X·X', 'X·X·XX', 'XX·XX·X'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('趣味练习'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab selector
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _tabChip(0, '节奏型', Icons.grid_on),
                _tabChip(1, '拍感', Icons.touch_app),
                _tabChip(2, '识谱', Icons.music_note),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildRhythmTraining(theme),
                _buildBeatSense(theme),
                _buildSightReading(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(int index, String label, IconData icon) {
    final isActive = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 11, color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Rhythm Training ----
  Widget _buildRhythmTraining(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('看节奏型，用手拍出来！', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          if (_currentPattern.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _currentPattern.split('').map((c) {
                  final isHit = c == 'X';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 36,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isHit ? theme.colorScheme.primary.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isHit ? theme.colorScheme.primary : Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isHit ? '●' : '○',
                          style: TextStyle(
                            fontSize: 20,
                            color: isHit ? theme.colorScheme.primary : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 20),
          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(_message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.colorScheme.primary)),
            ),
          Text('得分: $_score  |  第 $_round 题', style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 20),
          if (_message.contains('现在拍出来'))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TapActionButton('● 拍', theme.colorScheme.primary, tapRhythm),
                const SizedBox(width: 16),
                _TapActionButton('○ 空', Colors.grey, tapRest),
              ],
            ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              icon: Icon(_currentPattern.isEmpty ? Icons.play_arrow : Icons.refresh),
              label: Text(_currentPattern.isEmpty ? '开始挑战' : '下一题'),
              onPressed: _startRhythmRound,
            ),
          ),
        ],
      ),
    );
  }

  void _startRhythmRound() {
    final rand = Random();
    final isHard = _round >= 5;
    final pool = isHard ? _hardPatterns : _easyPatterns;
    final pattern = pool[rand.nextInt(pool.length)];

    setState(() {
      _currentPattern = pattern;
      _round++;
      _message = '记住这个节奏型，然后用下面的按钮拍出来！';
    });

    // Show pattern for 3 seconds then ask user to repeat
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _currentPattern.isNotEmpty) {
        setState(() {
          _message = '现在拍出来！点击 ● 按钮对应拍点';
          _userPattern = [];
        });
      }
    });
  }

  void tapRhythm() {
    if (_message.contains('现在拍出来')) {
      _userPattern.add(1);
      HapticFeedback.mediumImpact();

      if (_userPattern.length == _currentPattern.length) {
        _checkRhythmAnswer();
      }
    }
  }

  void tapRest() {
    if (_message.contains('现在拍出来')) {
      _userPattern.add(0);
      if (_userPattern.length == _currentPattern.length) {
        _checkRhythmAnswer();
      }
    }
  }

  void _checkRhythmAnswer() {
    final expected = _currentPattern.split('').map((c) => c == 'X' ? 1 : 0).toList();
    var correct = 0;
    for (int i = 0; i < expected.length; i++) {
      if (i < _userPattern.length && _userPattern[i] == expected[i]) {
        correct++;
      }
    }

    final accuracy = correct / expected.length;
    if (accuracy >= 0.8) {
      _score += 10;
      setState(() => _message = '✅ 太棒了！准确率 ${(accuracy * 100).round()}%');
    } else if (accuracy >= 0.5) {
      _score += 5;
      setState(() => _message = '👍 不错！准确率 ${(accuracy * 100).round()}%，继续加油');
    } else {
      setState(() => _message = '💪 再试一次！准确率 ${(accuracy * 100).round()}%');
    }
  }

  // ---- Beat Sense ----
  Widget _buildBeatSense(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('跟着节拍器拍打，看看你的节奏感！', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 24),
          Icon(Icons.touch_app, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text('即将上线', style: TextStyle(fontSize: 18, color: Colors.grey[400])),
          const SizedBox(height: 8),
          Text('跟着节拍器拍打，系统会分析你的拍点精度',
              style: TextStyle(fontSize: 13, color: Colors.grey[400], height: 1.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('提示: 先在节拍器页面设置好 BPM，再来这里练习拍感',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // ---- Sight Reading ----
  Widget _buildSightReading(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('识谱练习，认识基本节奏符号', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _noteCard(theme, '全音符', '𝅝', '4拍', '一个圆圈，数4拍'),
                _noteCard(theme, '二分音符', '𝅗𝅥', '2拍', '空心符头+符干'),
                _noteCard(theme, '四分音符', '♩', '1拍', '实心符头+符干'),
                _noteCard(theme, '八分音符', '♪', '1/2拍', '实心符头+符干+符尾'),
                _noteCard(theme, '十六分音符', '𝅘𝅥𝅯', '1/4拍', '两条符尾'),
                _noteCard(theme, '附点四分', '♩.', '1.5拍', '符头右边加一个点'),
                _noteCard(theme, '休止符', '𝄽', '1拍', '不发声，保持静默'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteCard(ThemeData theme, String name, String symbol, String duration, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(symbol, style: const TextStyle(fontSize: 24))),
        ),
        title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text('$duration  $desc', style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(duration, style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
        ),
      ),
    );
  }
}

class _TapActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TapActionButton(this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withValues(alpha: 0.3)),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
