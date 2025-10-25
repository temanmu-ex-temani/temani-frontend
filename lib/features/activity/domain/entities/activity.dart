class Activity {
  final String id;
  final String userId;
  final String feature;
  final String action;
  final String entityType;
  final String entityId;
  final String title;
  final String description;
  final DateTime timestamp;

  Activity({
    required this.id,
    required this.userId,
    required this.feature,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Activity(id: $id, feature: $feature, action: $action, title: $title, timestamp: $timestamp)';
  }
}
