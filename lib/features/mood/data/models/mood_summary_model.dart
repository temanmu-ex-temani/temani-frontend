import 'package:temanmu/features/mood/domain/entities/mood_summary.dart';

class MoodSummaryModel extends MoodSummary {
  const MoodSummaryModel({
    required super.moodAverage,
    required super.averageScore,
    required super.bestMood,
    required super.weeklyMood,
    required super.weekStart,
    required super.weekEnd,
  });

  factory MoodSummaryModel.fromJson(Map<String, dynamic> json) {
    return MoodSummaryModel(
      moodAverage: json['moodAverage'] as String? ?? '',
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      bestMood:
          json['bestMood'] != null
              ? BestMoodModel.fromJson(json['bestMood'] as Map<String, dynamic>)
              : const BestMoodModel(
                moodVisual: '',
                emotionScale: 0,
                date: '',
                dayOfWeek: '',
              ),
      weeklyMood:
          json['weeklyMood'] != null
              ? WeeklyMoodModel.fromJson(
                json['weeklyMood'] as Map<String, dynamic>,
              )
              : const WeeklyMoodModel(
                monday: '',
                tuesday: '',
                wednesday: '',
                thursday: '',
                friday: '',
                saturday: '',
                sunday: '',
                moodCounts: {},
              ),
      weekStart: json['weekStart'] as String? ?? '',
      weekEnd: json['weekEnd'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moodAverage': moodAverage,
      'averageScore': averageScore,
      'bestMood': (bestMood as BestMoodModel).toJson(),
      'weeklyMood': (weeklyMood as WeeklyMoodModel).toJson(),
      'weekStart': weekStart,
      'weekEnd': weekEnd,
    };
  }
}

class BestMoodModel extends BestMood {
  const BestMoodModel({
    required super.moodVisual,
    required super.emotionScale,
    required super.date,
    required super.dayOfWeek,
  });

  factory BestMoodModel.fromJson(Map<String, dynamic> json) {
    return BestMoodModel(
      moodVisual: json['moodVisual'] as String? ?? '',
      emotionScale: json['emotionScale'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moodVisual': moodVisual,
      'emotionScale': emotionScale,
      'date': date,
      'dayOfWeek': dayOfWeek,
    };
  }
}

class WeeklyMoodModel extends WeeklyMood {
  const WeeklyMoodModel({
    required super.monday,
    required super.tuesday,
    required super.wednesday,
    required super.thursday,
    required super.friday,
    required super.saturday,
    required super.sunday,
    required super.moodCounts,
  });

  factory WeeklyMoodModel.fromJson(Map<String, dynamic> json) {
    return WeeklyMoodModel(
      monday: json['monday'] as String? ?? '',
      tuesday: json['tuesday'] as String? ?? '',
      wednesday: json['wednesday'] as String? ?? '',
      thursday: json['thursday'] as String? ?? '',
      friday: json['friday'] as String? ?? '',
      saturday: json['saturday'] as String? ?? '',
      sunday: json['sunday'] as String? ?? '',
      moodCounts: Map<String, int>.from(
        json['moodCounts'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
      'moodCounts': moodCounts,
    };
  }
}

class MoodSummaryResponse {
  final bool success;
  final String message;
  final MoodSummaryModel data;
  final String timestamp;

  MoodSummaryResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory MoodSummaryResponse.fromJson(Map<String, dynamic> json) {
    return MoodSummaryResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: MoodSummaryModel.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }
}
