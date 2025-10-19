class CounselingScheduleModel {
  final String id;
  final String? clientId;
  final String counselorId;
  final String counselorName;
  final DateTime scheduledAt;
  final String title;
  final String description;
  final String meetingLink;
  final String notes;
  final String status;

  CounselingScheduleModel({
    required this.id,
    this.clientId,
    required this.counselorId,
    required this.counselorName,
    required this.scheduledAt,
    required this.title,
    required this.description,
    required this.meetingLink,
    required this.notes,
    required this.status,
  });

  factory CounselingScheduleModel.fromJson(Map<String, dynamic> json) {
    return CounselingScheduleModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String?,
      counselorId: json['counselorId'] as String,
      counselorName: json['counselorName'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      meetingLink: json['meetingLink'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (clientId != null) 'clientId': clientId,
      'counselorId': counselorId,
      'counselorName': counselorName,
      'scheduledAt': scheduledAt.toIso8601String(),
      'title': title,
      'description': description,
      'meetingLink': meetingLink,
      'notes': notes,
      'status': status,
    };
  }

  CounselingScheduleModel copyWith({
    String? id,
    String? clientId,
    String? counselorId,
    String? counselorName,
    DateTime? scheduledAt,
    String? title,
    String? description,
    String? meetingLink,
    String? notes,
    String? status,
  }) {
    return CounselingScheduleModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      counselorId: counselorId ?? this.counselorId,
      counselorName: counselorName ?? this.counselorName,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      title: title ?? this.title,
      description: description ?? this.description,
      meetingLink: meetingLink ?? this.meetingLink,
      notes: notes ?? this.notes,
      status: status ?? this.status,
    );
  }
}

class AvailableSchedulesResponse {
  final int status;
  final String message;
  final String timestamp;
  final List<CounselingScheduleModel> data;

  AvailableSchedulesResponse({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory AvailableSchedulesResponse.fromJson(Map<String, dynamic> json) {
    return AvailableSchedulesResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      data:
          (json['data'] as List)
              .map(
                (item) => CounselingScheduleModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class CounselingSchedulesResponse {
  final int status;
  final String message;
  final String timestamp;
  final List<CounselingScheduleModel> data;

  CounselingSchedulesResponse({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory CounselingSchedulesResponse.fromJson(Map<String, dynamic> json) {
    return CounselingSchedulesResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      data:
          (json['data'] as List)
              .map(
                (item) => CounselingScheduleModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}
