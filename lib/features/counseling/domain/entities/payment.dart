import 'package:intl/intl.dart';

class Payment {
  final String id;
  final String scheduleId;
  final String userId;
  final String midtransOrderId;
  final String? midtransTransactionId;
  final int amount;
  final String status;
  final String? paymentMethod;
  final String? paymentType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? paidAt;
  final String? failureReason;
  final String redirectUrl;
  final String token;

  const Payment({
    required this.id,
    required this.scheduleId,
    required this.userId,
    required this.midtransOrderId,
    this.midtransTransactionId,
    required this.amount,
    required this.status,
    this.paymentMethod,
    this.paymentType,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
    this.failureReason,
    required this.redirectUrl,
    required this.token,
  });

  bool get isSuccessful => status == 'SETTLED' || status == 'SUCCESS';
  bool get isPending => status == 'PENDING';
  bool get isFailed =>
      status == 'FAILURE' || status == 'CANCEL' || status == 'EXPIRE';

  // Helper method for formatted amount
  String get formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
