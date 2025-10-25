import 'package:temani_frontend/features/mood/domain/entities/mood_log.dart';

class MoodLogModel extends MoodLog {
  MoodLogModel({
    required super.id,
    required super.userId,
    required super.moodVisual,
    required super.emotionScale,
    required super.timestamp,
  });

  factory MoodLogModel.fromJson(Map<String, dynamic> json) {
    return MoodLogModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      moodVisual: json['moodVisual'] as String? ?? '',
      emotionScale: json['emotionScale'] as int? ?? 3,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'moodVisual': moodVisual,
      'emotionScale': emotionScale,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  MoodLogModel copyWith({
    String? id,
    String? userId,
    String? moodVisual,
    int? emotionScale,
    DateTime? timestamp,
  }) {
    return MoodLogModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodVisual: moodVisual ?? this.moodVisual,
      emotionScale: emotionScale ?? this.emotionScale,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class MoodLogRequest {
  final String moodVisual;
  final int emotionScale;

  MoodLogRequest({required this.moodVisual, required this.emotionScale});

  Map<String, dynamic> toJson() {
    return {'moodVisual': moodVisual, 'emotionScale': emotionScale};
  }
}

class MoodLogResponse {
  final bool success;
  final String message;
  final MoodLogModel? data;
  final String timestamp;

  MoodLogResponse({
    required this.success,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory MoodLogResponse.fromJson(Map<String, dynamic> json) {
    return MoodLogResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data:
          json['data'] != null
              ? MoodLogModel.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }
}

class MoodLogListResponse {
  final bool success;
  final String message;
  final List<MoodLogModel> data;
  final String timestamp;

  MoodLogListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory MoodLogListResponse.fromJson(Map<String, dynamic> json) {
    return MoodLogListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => MoodLogModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
    };
  }
}
