class PaymentRequest {
  final String scheduleId;
  final int fee;

  const PaymentRequest({required this.scheduleId, required this.fee});

  Map<String, dynamic> toJson() {
    return {'scheduleId': scheduleId, 'fee': fee};
  }
}
