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
  // ===== 经典节奏 =====
  // 架子鼓
  const RhythmPreset(
    name: 'Rock',
    category: '经典节奏',
    bpm: 120,
    beatsPerMeasure: 4,
    description: '架子鼓 · 经典摇滚 4/4 120BPM',
  ),
  const RhythmPreset(
    name: 'Ballad',
    category: '经典节奏',
    bpm: 72,
    beatsPerMeasure: 4,
    description: '架子鼓 · 抒情慢歌 4/4 72BPM',
  ),
  const RhythmPreset(
    name: 'Shuffle',
    category: '经典节奏',
    bpm: 100,
    beatsPerMeasure: 6,
    beatUnit: 8,
    description: '架子鼓 · 摇摆节奏 6/8 100BPM',
  ),
  const RhythmPreset(
    name: 'Funk',
    category: '经典节奏',
    bpm: 110,
    beatsPerMeasure: 4,
    description: '架子鼓 · 放克切分 4/4 110BPM',
  ),
  const RhythmPreset(
    name: 'Metal',
    category: '经典节奏',
    bpm: 180,
    beatsPerMeasure: 4,
    description: '架子鼓 · 重型金属 4/4 180BPM',
  ),
  const RhythmPreset(
    name: 'Basic Strum',
    category: '经典节奏',
    bpm: 80,
    beatsPerMeasure: 4,
    description: '尤克里里 · 基础扫弦 4/4 80BPM',
  ),
  const RhythmPreset(
    name: 'Waltz',
    category: '经典节奏',
    bpm: 60,
    beatsPerMeasure: 3,
    description: '尤克里里 · 华尔兹 3/4 60BPM',
  ),
  const RhythmPreset(
    name: 'Folk',
    category: '经典节奏',
    bpm: 96,
    beatsPerMeasure: 4,
    description: '尤克里里 · 民谣弹唱 4/4 96BPM',
  ),
  const RhythmPreset(
    name: 'Reggae',
    category: '经典节奏',
    bpm: 90,
    beatsPerMeasure: 4,
    description: '尤克里里 · 雷鬼律动 4/4 90BPM',
  ),
  // ===== 歌曲预设 =====
  const RhythmPreset(
    name: 'Billie Jean',
    category: '歌曲预设',
    bpm: 117,
    beatsPerMeasure: 4,
    description: 'Michael Jackson · 鼓手入门经典',
  ),
  const RhythmPreset(
    name: 'Back in Black',
    category: '歌曲预设',
    bpm: 192,
    beatsPerMeasure: 4,
    description: 'AC/DC · 硬摇滚八分律动',
  ),
  const RhythmPreset(
    name: 'Come Together',
    category: '歌曲预设',
    bpm: 80,
    beatsPerMeasure: 4,
    description: 'The Beatles · 经典摇滚 shuffle',
  ),
  const RhythmPreset(
    name: 'Stayin Alive',
    category: '歌曲预设',
    bpm: 103,
    beatsPerMeasure: 4,
    description: 'Bee Gees · 鼓点四连音练习',
  ),
  const RhythmPreset(
    name: 'Seven Nation Army',
    category: '歌曲预设',
    bpm: 124,
    beatsPerMeasure: 4,
    description: 'The White Stripes · 简单有力',
  ),
  const RhythmPreset(
    name: 'Bohemian Rhapsody',
    category: '歌曲预设',
    bpm: 72,
    beatsPerMeasure: 4,
    description: 'Queen · 变速段落练习',
  ),
  const RhythmPreset(
    name: '晴天',
    category: '歌曲预设',
    bpm: 84,
    beatsPerMeasure: 4,
    description: '周杰伦 · 流行弹唱 4/4 84BPM',
  ),
  const RhythmPreset(
    name: '夜曲',
    category: '歌曲预设',
    bpm: 75,
    beatsPerMeasure: 4,
    description: '周杰伦 · 慢速抒情 4/4 75BPM',
  ),
  const RhythmPreset(
    name: '旅行的意义',
    category: '歌曲预设',
    bpm: 96,
    beatsPerMeasure: 4,
    description: '陈绮贞 · 尤克里里经典弹唱',
  ),
  const RhythmPreset(
    name: '小幸运',
    category: '歌曲预设',
    bpm: 82,
    beatsPerMeasure: 4,
    description: '田馥甄 · 流行弹唱 4/4 82BPM',
  ),
  const RhythmPreset(
    name: '你笑起来真好看',
    category: '歌曲预设',
    bpm: 100,
    beatsPerMeasure: 4,
    description: '流行儿歌 · 尤克里里入门必弹 4/4 100BPM',
  ),
];

List<RhythmPreset> presetsByCategory(String category) {
  return presets.where((p) => p.category == category).toList();
}

List<String> get presetCategories =>
    presets.map((p) => p.category).toSet().toList();
