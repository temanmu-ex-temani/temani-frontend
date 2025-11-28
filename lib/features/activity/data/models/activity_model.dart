import 'package:temanmu/features/activity/domain/entities/activity.dart';

class ActivityModel extends Activity {
  ActivityModel({
    required super.id,
    required super.userId,
    required super.feature,
    required super.action,
    required super.entityType,
    required super.entityId,
    required super.title,
    required super.description,
    required super.timestamp,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      feature: json['feature'] as String? ?? '',
      action: json['action'] as String? ?? '',
      entityType: json['entityType'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'feature': feature,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  ActivityModel copyWith({
    String? id,
    String? userId,
    String? feature,
    String? action,
    String? entityType,
    String? entityId,
    String? title,
    String? description,
    DateTime? timestamp,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      feature: feature ?? this.feature,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ActivityListResponse {
  final bool success;
  final String message;
  final List<ActivityModel> data;
  final String timestamp;

  ActivityListResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory ActivityListResponse.fromJson(Map<String, dynamic> json) {
    return ActivityListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => ActivityModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
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
