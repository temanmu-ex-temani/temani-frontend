import 'package:equatable/equatable.dart';

class MoodSummary extends Equatable {
  final String moodAverage;
  final double averageScore;
  final BestMood bestMood;
  final WeeklyMood weeklyMood;
  final String weekStart;
  final String weekEnd;

  const MoodSummary({
    required this.moodAverage,
    required this.averageScore,
    required this.bestMood,
    required this.weeklyMood,
    required this.weekStart,
    required this.weekEnd,
  });

  @override
  List<Object?> get props => [
    moodAverage,
    averageScore,
    bestMood,
    weeklyMood,
    weekStart,
    weekEnd,
  ];
}

class BestMood extends Equatable {
  final String moodVisual;
  final int emotionScale;
  final String date;
  final String dayOfWeek;

  const BestMood({
    required this.moodVisual,
    required this.emotionScale,
    required this.date,
    required this.dayOfWeek,
  });

  @override
  List<Object?> get props => [moodVisual, emotionScale, date, dayOfWeek];
}

class WeeklyMood extends Equatable {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;
  final Map<String, int> moodCounts;

  const WeeklyMood({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
    required this.moodCounts,
  });

  @override
  List<Object?> get props => [
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
    moodCounts,
  ];
}
