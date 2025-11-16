part of '_environments.dart';

class EndPoints {
  // Base Endpoints
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Counseling Endpoints
  static const String counselingSchedulesAvailable =
      '$baseUrl/counseling-schedules/available';
  static const String counselingSchedules = '$baseUrl/counseling-schedules';
  static const String counselingSchedulesPeer =
      '$baseUrl/counseling-schedules/peer';
  static String counselingScheduleStatus(String scheduleId) =>
      '$baseUrl/counseling-schedules/$scheduleId/status';

  // Payment Endpoints
  static const String paymentCreate = '$baseUrl/payments/create';
  static const String paymentStatus = '$baseUrl/payments/status';

  // Journal Endpoints
  static const String journals = '$baseUrl/journals';

  // Activity/Interaction Logs Endpoints
  static const String interactionLogs = '$baseUrl/interaction-logs';
  static String interactionLogsByFeature(String feature) =>
      '$baseUrl/interaction-logs/feature/$feature';
  static String interactionLogsByUser(String userId) =>
      '$baseUrl/interaction-logs/user/$userId';
  static const String interactionLogsTest = '$baseUrl/interaction-logs/test';

  // Mood Logs Endpoints
  static const String moodLogs = '$baseUrl/mood-logs';
  static String moodLogById(String id) => '$baseUrl/mood-logs/$id';
  static const String moodSummary = '$baseUrl/mood-logs/summary';
  static String moodSummaryByUser(String userId) =>
      '$baseUrl/mood-logs/summary/user/$userId';

  // Profile Endpoints
  static const String profileMe = '$baseUrl/profiles/me';

  // Relationship Endpoints
  static const String relationships = '$baseUrl/relationships';
  static String relationshipById(String id) => '$baseUrl/relationships/$id';
  static const String relationshipsSearch = '$baseUrl/relationships/search';

  // Todo Endpoints
  static const String todoLists = '$baseUrl/todo-lists';
  static const String todoListsCreate = '$baseUrl/todo-lists/create';
  static String todoListById(String id) => '$baseUrl/todo-lists/$id';
  static const String todoItems = '$baseUrl/todo-items';
  static String todoItemsByList(String listId) => '$baseUrl/todo-items/$listId';
  static String todoItemById(String id) => '$baseUrl/todo-items/$id';
  static String todoItemToggle(String id) =>
      '$baseUrl/todo-items/$id/toggle';
}
