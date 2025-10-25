class MoodLog {
  final String id;
  final String userId;
  final String moodVisual;
  final int emotionScale;
  final DateTime timestamp;

  MoodLog({
    required this.id,
    required this.userId,
    required this.moodVisual,
    required this.emotionScale,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MoodLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MoodLog(id: $id, moodVisual: $moodVisual, emotionScale: $emotionScale, timestamp: $timestamp)';
  }
}
