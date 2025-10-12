import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
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

  const PaymentModel({
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

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      scheduleId: json['scheduleId'] as String,
      userId: json['userId'] as String,
      midtransOrderId: json['midtransOrderId'] as String,
      midtransTransactionId: json['midtransTransactionId'] as String?,
      amount: json['amount'] as int,
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String?,
      paymentType: json['paymentType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      paidAt:
          json['paidAt'] != null
              ? DateTime.parse(json['paidAt'] as String)
              : null,
      failureReason: json['failureReason'] as String?,
      redirectUrl: json['redirectUrl'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'userId': userId,
      'midtransOrderId': midtransOrderId,
      'midtransTransactionId': midtransTransactionId,
      'amount': amount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentType': paymentType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'failureReason': failureReason,
      'redirectUrl': redirectUrl,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    userId,
    midtransOrderId,
    midtransTransactionId,
    amount,
    status,
    paymentMethod,
    paymentType,
    createdAt,
    updatedAt,
    paidAt,
    failureReason,
    redirectUrl,
    token,
  ];
}

class PaymentRequestModel extends Equatable {
  final String scheduleId;
  final int fee;

  const PaymentRequestModel({required this.scheduleId, required this.fee});

  Map<String, dynamic> toJson() {
    return {'scheduleId': scheduleId, 'fee': fee};
  }

  @override
  List<Object?> get props => [scheduleId, fee];
}

class PaymentResponseModel extends Equatable {
  final int status;
  final String message;
  final String timestamp;
  final PaymentModel data;

  const PaymentResponseModel({
    required this.status,
    required this.message,
    required this.timestamp,
    required this.data,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      status: json['status'] as int,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
      data: PaymentModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [status, message, timestamp, data];
}
