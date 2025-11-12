class Relationship {
  final String id;
  final String clientId;
  final String? clientName;
  final String caregiverId;
  final String? caregiverName;
  final String initiatorId;
  final bool accepted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Relationship({
    required this.id,
    required this.clientId,
    this.clientName,
    required this.caregiverId,
    this.caregiverName,
    required this.initiatorId,
    required this.accepted,
    required this.createdAt,
    required this.updatedAt,
  });
}

class PotentialRelationship {
  final String userId;
  final String name;
  final String username;
  final List<Role> roles;
  final RelationshipStatus relationshipStatus;

  PotentialRelationship({
    required this.userId,
    required this.name,
    required this.username,
    required this.roles,
    required this.relationshipStatus,
  });
}

class Role {
  final String id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });
}

enum RelationshipStatus {
  none,
  sent,
  received,
  connected,
  connectedToOther,
}

