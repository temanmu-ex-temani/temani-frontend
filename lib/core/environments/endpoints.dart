part of '_environments.dart';

class EndPoints {
  // Base Endpoints
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Counseling Endpoints
  static const String counselingSchedulesAvailable =
      '$baseUrl/counseling-schedules/available';
  static const String counselingSchedules = '$baseUrl/counseling-schedules';

  // Payment Endpoints
  static const String paymentCreate = '$baseUrl/payments/create';
  static const String paymentStatus = '$baseUrl/payments/status';

  // Journal Endpoints
  static const String journals = '$baseUrl/journals';

  // Activity/Interaction Logs Endpoints
  static const String interactionLogs = '$baseUrl/interaction-logs';
  static String interactionLogsByFeature(String feature) =>
      '$baseUrl/interaction-logs/feature/$feature';
  static const String interactionLogsTest = '$baseUrl/interaction-logs/test';

  // Mood Logs Endpoints
  static const String moodLogs = '$baseUrl/mood-logs';
  static String moodLogById(String id) => '$baseUrl/mood-logs/$id';
  static const String moodSummary = '$baseUrl/mood-logs/summary';
}
