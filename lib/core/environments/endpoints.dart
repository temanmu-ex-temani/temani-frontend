part of '_environments.dart';

class EndPoints {
  // Base Endpoints
  static const String baseUrl = 'http://10.0.2.2:8080';

  // Counseling Endpoints
  static const String counselingSchedulesAvailable =
      '$baseUrl/counseling-schedules/available';

  // Payment Endpoints
  static const String paymentCreate = '$baseUrl/payments/create';
  static const String paymentStatus = '$baseUrl/payments/status';
}
