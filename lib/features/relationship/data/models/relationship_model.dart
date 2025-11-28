import 'package:temanmu/features/relationship/domain/entities/relationship.dart';

class RelationshipModel extends Relationship {
  RelationshipModel({
    required super.id,
    required super.clientId,
    super.clientName,
    required super.caregiverId,
    super.caregiverName,
    required super.initiatorId,
    required super.accepted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory RelationshipModel.fromJson(Map<String, dynamic> json) {
    return RelationshipModel(
      id: json['id'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      clientName: json['clientName'] as String?,
      caregiverId: json['caregiverId'] as String? ?? '',
      caregiverName: json['caregiverName'] as String?,
      initiatorId: json['initiatorId'] as String? ?? '',
      accepted: json['accepted'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'clientName': clientName,
      'caregiverId': caregiverId,
      'caregiverName': caregiverName,
      'initiatorId': initiatorId,
      'accepted': accepted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class PotentialRelationshipModel extends PotentialRelationship {
  PotentialRelationshipModel({
    required super.userId,
    required super.name,
    required super.username,
    required super.roles,
    required super.relationshipStatus,
  });

  factory PotentialRelationshipModel.fromJson(Map<String, dynamic> json) {
    final statusString = json['relationshipStatus'] as String? ?? 'NONE';
    RelationshipStatus status;
    switch (statusString.toUpperCase()) {
      case 'SENT':
        status = RelationshipStatus.sent;
        break;
      case 'RECEIVED':
        status = RelationshipStatus.received;
        break;
      case 'CONNECTED':
        status = RelationshipStatus.connected;
        break;
      case 'CONNECTED_TO_OTHER':
        status = RelationshipStatus.connectedToOther;
        break;
      default:
        status = RelationshipStatus.none;
    }

    return PotentialRelationshipModel(
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
              ?.map((item) => Role(
                    id: item['id'] as String? ?? '',
                    name: item['name'] as String? ?? '',
                  ))
              .toList() ??
          [],
      relationshipStatus: status,
    );
  }
}

class RelationshipResponse {
  final int status;
  final String message;
  final RelationshipModel? data;
  final String timestamp;

  RelationshipResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory RelationshipResponse.fromJson(Map<String, dynamic> json) {
    return RelationshipResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? RelationshipModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class RelationshipListResponse {
  final int status;
  final String message;
  final List<RelationshipModel> data;
  final String timestamp;

  RelationshipListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory RelationshipListResponse.fromJson(Map<String, dynamic> json) {
    return RelationshipListResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  RelationshipModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class PotentialRelationshipListResponse {
  final int status;
  final String message;
  final List<PotentialRelationshipModel> data;
  final String timestamp;

  PotentialRelationshipListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory PotentialRelationshipListResponse.fromJson(
      Map<String, dynamic> json) {
    return PotentialRelationshipListResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => PotentialRelationshipModel.fromJson(
                  item as Map<String, dynamic>))
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class CreateRelationshipRequest {
  final String targetId;

  CreateRelationshipRequest({required this.targetId});

  Map<String, dynamic> toJson() {
    return {'targetId': targetId};
  }
}

class UpdateRelationshipStatusRequest {
  final String status;

  UpdateRelationshipStatusRequest({required this.status});

  Map<String, dynamic> toJson() {
    return {'status': status};
  }
}

