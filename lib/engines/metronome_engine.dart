import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../models/metronome_state.dart';

class MetronomeEngine {
  Timer? _timer;
  Timer? _countdownTimer;
  int _currentBeat = 0;
  int _totalBeats = 0;
  int _remainingSeconds = 0;

  final AudioPlayer _accentPlayer = AudioPlayer();
  final AudioPlayer _normalPlayer = AudioPlayer();
  final AudioPlayer _drumPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isPaused = false;
  bool _disposed = false;

  int bpm = 120;
  int beatsPerMeasure = 4;
  int beatUnit = 4;
  bool accentEnabled = true;
  double volume = 0.8;
  bool timerEnabled = false;
  int timerDurationMinutes = 0;
  SoundScheme soundScheme = SoundScheme.classic;
  bool vibrateEnabled = false;

  void Function(int currentBeat, bool isAccent, int totalBeats)? onBeat;
  void Function(int remainingSeconds)? onTimerTick;
  void Function()? onTimerComplete;
  void Function()? onPlayStateChanged;

  Future<void> init() async {
    await _loadSounds();
    _accentPlayer.setVolume(volume);
    _normalPlayer.setVolume(volume * 0.7);
    _drumPlayer.setVolume(volume);
  }

  Future<void> _loadSounds() async {
    switch (soundScheme) {
      case SoundScheme.classic:
        await _accentPlayer.setSource(AssetSource('sounds/click_high.wav'));
        await _normalPlayer.setSource(AssetSource('sounds/click_low.wav'));
        break;
      case SoundScheme.wood:
        await _accentPlayer.setSource(AssetSource('sounds/click_high.wav'));
        await _normalPlayer.setSource(AssetSource('sounds/click_low.wav'));
        break;
      case SoundScheme.electronic:
        await _accentPlayer.setSource(AssetSource('sounds/rim.wav'));
        await _normalPlayer.setSource(AssetSource('sounds/click_low.wav'));
        break;
      case SoundScheme.drumKit:
        await _drumPlayer.setSource(AssetSource('sounds/kick.wav'));
        await _accentPlayer.setSource(AssetSource('sounds/snare.wav'));
        await _normalPlayer.setSource(AssetSource('sounds/hihat.wav'));
        break;
    }
  }

  Future<void> reloadSounds() async {
    if (_disposed) return;
    await _loadSounds();
  }

  void setVolume(double v) {
    volume = v;
    _accentPlayer.setVolume(v);
    _normalPlayer.setVolume(v * 0.7);
    _drumPlayer.setVolume(v);
  }

  void play() {
    if (_isPlaying && !_isPaused) return;
    if (_disposed) return;

    _isPlaying = true;
    _isPaused = false;
    _currentBeat = 0;
    if (!timerEnabled) _remainingSeconds = 0;

    onPlayStateChanged?.call();
    _scheduleBeat();
    _startCountdownIfNeeded();
  }

  void pause() {
    if (!_isPlaying || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    _cancelCountdown();
    onPlayStateChanged?.call();
  }

  void resume() {
    if (!_isPlaying || !_isPaused) return;
    _isPaused = false;
    onPlayStateChanged?.call();
    _scheduleBeat();
    _startCountdownIfNeeded();
  }

  void stop() {
    _isPlaying = false;
    _isPaused = false;
    _currentBeat = 0;
    _timer?.cancel();
    _cancelCountdown();
    _remainingSeconds = 0;
    onTimerTick?.call(0);
    onPlayStateChanged?.call();
  }

  void togglePlayPause() {
    if (!_isPlaying) {
      play();
    } else if (_isPaused) {
      resume();
    } else {
      pause();
    }
  }

  Future<void> _playBeat(int beatIndex, bool isAccent) async {
    try {
      if (soundScheme == SoundScheme.drumKit) {
        // Drum kit mode: different drums for different beats
        if (beatIndex == 0) {
          // Beat 1 = Kick + Snare accent
          HapticFeedback.heavyImpact();
          await _drumPlayer.stop();
          await _drumPlayer.play(AssetSource('sounds/kick.wav'));
          final snare = AudioPlayer();
          await snare.setSource(AssetSource('sounds/snare.wav'));
          snare.setVolume(volume * 0.6);
          await snare.resume();
        } else if (beatIndex % 2 == 0) {
          // Even beats = Snare (backbeat)
          if (vibrateEnabled) HapticFeedback.lightImpact();
          await _accentPlayer.stop();
          await _accentPlayer.play(AssetSource('sounds/snare.wav'));
        } else {
          // Odd beats = Hi-hat
          await _normalPlayer.stop();
          await _normalPlayer.play(AssetSource('sounds/hihat.wav'));
        }
      } else if (isAccent && accentEnabled) {
        HapticFeedback.heavyImpact();
        await _accentPlayer.stop();
        await _accentPlayer.play(AssetSource('sounds/click_high.wav'));
      } else {
        if (vibrateEnabled) HapticFeedback.lightImpact();
        await _normalPlayer.stop();
        await _normalPlayer.play(AssetSource('sounds/click_low.wav'));
      }
    } catch (_) {}
  }

  void _scheduleBeat() {
    _timer?.cancel();
    if (_disposed || !_isPlaying || _isPaused) return;

    _currentBeat = (_currentBeat % beatsPerMeasure);
    final isAccent = (_currentBeat == 0);
    _totalBeats++;

    onBeat?.call(_currentBeat, isAccent, _totalBeats);
    _playBeat(_currentBeat, isAccent);

    final intervalMs = (60000 / bpm).round();
    _timer = Timer(Duration(milliseconds: intervalMs), () {
      _currentBeat++;
      _scheduleBeat();
    });
  }

  void _startCountdownIfNeeded() {
    if (!timerEnabled || timerDurationMinutes <= 0) return;
    _remainingSeconds = timerDurationMinutes * 60;
    onTimerTick?.call(_remainingSeconds);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed || _isPaused) return;
      _remainingSeconds--;
      onTimerTick?.call(_remainingSeconds);
      if (_remainingSeconds <= 0) {
        stop();
        onTimerComplete?.call();
      }
    });
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;

  void dispose() {
    _disposed = true;
    stop();
    _accentPlayer.dispose();
    _normalPlayer.dispose();
    _drumPlayer.dispose();
  }
}
