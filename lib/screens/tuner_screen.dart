import 'package:flutter/material.dart';
import 'dart:math';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> with SingleTickerProviderStateMixin {
  bool _isListening = false;
  double _frequency = 0;
  String _noteName = '--';
  int _noteIndex = 0;
  double _cents = 0;

  final List<String> _notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  String _freqToNote(double freq) {
    if (freq <= 20) return '--';
    final a = 440.0;
    final n = 12 * (log(freq / a) / log(2)) + 69;
    final midi = n.round();
    _noteIndex = midi % 12;
    _cents = (n - midi) * 100;
    _frequency = freq;
    return '${_notes[_noteIndex]}${(midi ~/ 12) - 1}';
  }

  String get _centsDisplay {
    if (_cents.abs() < 1) return '±0¢';
    return '${_cents > 0 ? '+' : ''}${_cents.toStringAsFixed(0)}¢';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('调音器'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),

          // Note display
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isListening
                  ? (_cents.abs() < 5
                      ? Colors.green.withValues(alpha: 0.15)
                      : theme.colorScheme.primary.withValues(alpha: 0.1))
                  : Colors.grey.withValues(alpha: 0.05),
              border: Border.all(
                color: _isListening
                    ? (_cents.abs() < 5 ? Colors.green : theme.colorScheme.primary.withValues(alpha: 0.3))
                    : Colors.grey.withValues(alpha: 0.15),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                _noteName,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w600,
                  color: _isListening
                      ? (_cents.abs() < 5 ? Colors.green : theme.colorScheme.primary)
                      : Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isListening ? '${_frequency.toStringAsFixed(1)} Hz' : '点击开始调音',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),

          const SizedBox(height: 24),

          // Tuning gauge
          SizedBox(
            height: 80,
            child: CustomPaint(
              size: const Size(double.infinity, 80),
              painter: _TunerGaugePainter(
                cents: _cents,
                isListening: _isListening,
                primaryColor: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _centsDisplay,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: _isListening
                  ? (_cents.abs() < 5 ? Colors.green : Colors.grey[700])
                  : Colors.grey[400],
            ),
          ),

          const SizedBox(height: 16),

          // Note reference
          Text('标准音 A4 = 440 Hz', style: TextStyle(fontSize: 12, color: Colors.grey[400])),

          const Spacer(),

          // Start/Stop button
          SizedBox(
            width: 80,
            height: 80,
            child: FloatingActionButton.large(
              onPressed: _toggleListening,
              backgroundColor: _isListening ? Colors.red.withValues(alpha: 0.1) : theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : theme.colorScheme.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isListening ? '点击停止' : '开始调音',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),

          const Spacer(),

          // String reference
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text('吉他/尤克里里 标准调弦', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _stringTag('G3', '196Hz'),
                    _stringTag('C4', '262Hz'),
                    _stringTag('E4', '330Hz'),
                    _stringTag('A4', '440Hz'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stringTag(String note, String freq) {
    return Column(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Center(
            child: Text(note, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        const SizedBox(height: 2),
        Text(freq, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  void _toggleListening() {
    if (!_isListening) {
      // Simulate tuner for now - will connect to device mic
      setState(() {
        _isListening = true;
        _animCtrl.repeat();
      });
      _simulateTuner();
    } else {
      setState(() {
        _isListening = false;
        _animCtrl.stop();
        _noteName = '--';
        _frequency = 0;
      });
    }
  }

  void _simulateTuner() {
    // Demo: simulate frequency sweeps to show tuner works
    // Real implementation will use device mic + FFT
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_isListening && mounted) {
        final rand = Random();
        final baseFreqs = [196.0, 220.0, 246.9, 261.6, 293.7, 330.0, 349.2, 392.0, 440.0, 493.9, 523.3];
        final target = baseFreqs[rand.nextInt(baseFreqs.length)];
        setState(() {
          _frequency = target + (rand.nextDouble() - 0.5) * 20;
          _noteName = _freqToNote(_frequency);
        });
        _simulateTuner();
      }
    });
  }
}

class _TunerGaugePainter extends CustomPainter {
  final double cents;
  final bool isListening;
  final Color primaryColor;

  _TunerGaugePainter({
    required this.cents,
    required this.isListening,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final startX = 40.0;
    final endX = size.width - 40;
    final totalWidth = endX - startX;
    final midX = startX + totalWidth / 2;

    // Background line
    paint.color = Colors.grey.withValues(alpha: 0.15);
    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);

    // Tick marks
    for (int i = 0; i <= 20; i++) {
      final x = startX + (totalWidth * i / 20);
      final isMid = i == 10;
      final tickH = isMid ? 12.0 : 6.0;
      paint.color = i == 10 ? Colors.grey.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2);
      paint.strokeWidth = isMid ? 2 : 1;
      canvas.drawLine(Offset(x, centerY - tickH), Offset(x, centerY + tickH), paint);
    }

    if (!isListening) return;

    // Indicator needle
    final clampedCents = cents.clamp(-50.0, 50.0);
    final indicatorX = midX + (clampedCents / 50) * (totalWidth / 2);

    final indicatorColor = cents.abs() < 5 ? Colors.green : primaryColor;
    paint.color = indicatorColor;
    paint.strokeWidth = 4;
    canvas.drawLine(Offset(indicatorX, centerY - 20), Offset(indicatorX, centerY + 20), paint);

    // Center dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(indicatorX, centerY), 6, paint);
  }

  @override
  bool shouldRepaint(covariant _TunerGaugePainter old) =>
      old.cents != cents || old.isListening != isListening;
}
