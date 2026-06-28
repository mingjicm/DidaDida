class RhythmPreset {
  final String name;
  final String category;
  final int bpm;
  final int beatsPerMeasure;
  final int beatUnit;
  final String description;

  const RhythmPreset({
    required this.name,
    required this.category,
    required this.bpm,
    required this.beatsPerMeasure,
    this.beatUnit = 4,
    required this.description,
  });
}

final List<RhythmPreset> presets = [
  // 架子鼓类
  const RhythmPreset(
    name: 'Rock',
    category: '架子鼓',
    bpm: 120,
    beatsPerMeasure: 4,
    description: '经典摇滚节奏，4/4 拍 120 BPM',
  ),
  const RhythmPreset(
    name: 'Ballad',
    category: '架子鼓',
    bpm: 72,
    beatsPerMeasure: 4,
    description: '抒情慢歌，4/4 拍 72 BPM',
  ),
  const RhythmPreset(
    name: 'Shuffle',
    category: '架子鼓',
    bpm: 100,
    beatsPerMeasure: 6,
    beatUnit: 8,
    description: '摇摆节奏，6/8 拍 100 BPM',
  ),
  const RhythmPreset(
    name: 'Funk',
    category: '架子鼓',
    bpm: 110,
    beatsPerMeasure: 4,
    description: '放克切分，4/4 拍 110 BPM',
  ),
  const RhythmPreset(
    name: 'Metal',
    category: '架子鼓',
    bpm: 180,
    beatsPerMeasure: 4,
    description: '重型金属，4/4 拍 180 BPM',
  ),
  // 尤克里里类
  const RhythmPreset(
    name: 'Basic Strum',
    category: '尤克里里',
    bpm: 80,
    beatsPerMeasure: 4,
    description: '基础扫弦练习，4/4 拍 80 BPM',
  ),
  const RhythmPreset(
    name: 'Waltz',
    category: '尤克里里',
    bpm: 60,
    beatsPerMeasure: 3,
    description: '华尔兹 3/4 拍，适合分解和弦',
  ),
  const RhythmPreset(
    name: 'Folk',
    category: '尤克里里',
    bpm: 96,
    beatsPerMeasure: 4,
    description: '民谣弹唱节奏，4/4 拍 96 BPM',
  ),
  const RhythmPreset(
    name: 'Reggae',
    category: '尤克里里',
    bpm: 90,
    beatsPerMeasure: 4,
    description: '雷鬼反拍律动，4/4 拍 90 BPM',
  ),
];

List<RhythmPreset> presetsByCategory(String category) {
  return presets.where((p) => p.category == category).toList();
}
