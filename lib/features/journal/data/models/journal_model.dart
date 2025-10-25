class JournalModel {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  JournalModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class JournalRequest {
  final String title;
  final String content;

  JournalRequest({required this.title, required this.content});

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content};
  }
}

class JournalResponse {
  final int status;
  final String message;
  final JournalModel? data;
  final String timestamp;

  JournalResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory JournalResponse.fromJson(Map<String, dynamic> json) {
    return JournalResponse(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data:
          json['data'] != null
              ? JournalModel.fromJson(json['data'] as Map<String, dynamic>)
              : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class JournalListResponse {
  final int status;
  final String message;
  final List<JournalModel> data;
  final String timestamp;

  JournalListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory JournalListResponse.fromJson(Map<String, dynamic> json) {
    return JournalListResponse(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data:
          json['data'] != null
              ? (json['data'] as List)
                  .map(
                    (item) =>
                        JournalModel.fromJson(item as Map<String, dynamic>),
                  )
                  .toList()
              : <JournalModel>[],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}
