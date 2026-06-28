class MetronomeState {
  final int bpm;
  final int beatsPerMeasure;
  final int beatUnit;
  final bool accentEnabled;
  final double volume;
  final bool isPlaying;
  final bool isPaused;
  final int currentBeat;
  final int totalBeats;
  final int remainingSeconds;
  final bool timerEnabled;
  final bool vibrateEnabled;
  final bool keepScreenOn;
  final SoundScheme soundScheme;
  final String? activePreset;

  const MetronomeState({
    this.bpm = 120,
    this.beatsPerMeasure = 4,
    this.beatUnit = 4,
    this.accentEnabled = true,
    this.volume = 0.8,
    this.isPlaying = false,
    this.isPaused = false,
    this.currentBeat = 0,
    this.totalBeats = 0,
    this.remainingSeconds = 0,
    this.timerEnabled = false,
    this.vibrateEnabled = false,
    this.keepScreenOn = true,
    this.soundScheme = SoundScheme.classic,
    this.activePreset,
  });

  MetronomeState copyWith({
    int? bpm,
    int? beatsPerMeasure,
    int? beatUnit,
    bool? accentEnabled,
    double? volume,
    bool? isPlaying,
    bool? isPaused,
    int? currentBeat,
    int? totalBeats,
    int? remainingSeconds,
    bool? timerEnabled,
    bool? vibrateEnabled,
    bool? keepScreenOn,
    SoundScheme? soundScheme,
    String? activePreset,
  }) {
    return MetronomeState(
      bpm: bpm ?? this.bpm,
      beatsPerMeasure: beatsPerMeasure ?? this.beatsPerMeasure,
      beatUnit: beatUnit ?? this.beatUnit,
      accentEnabled: accentEnabled ?? this.accentEnabled,
      volume: volume ?? this.volume,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      currentBeat: currentBeat ?? this.currentBeat,
      totalBeats: totalBeats ?? this.totalBeats,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      vibrateEnabled: vibrateEnabled ?? this.vibrateEnabled,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      soundScheme: soundScheme ?? this.soundScheme,
      activePreset: activePreset ?? this.activePreset,
    );
  }

  double get intervalMs => 60000.0 / bpm;
}

enum SoundScheme { classic, wood, electronic }
