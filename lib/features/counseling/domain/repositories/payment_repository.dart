import 'package:either_dart/either.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/domain/entities/payment.dart';
import 'package:temani_frontend/features/counseling/domain/entities/payment_request.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createPayment(PaymentRequest request);
  Future<Either<Failure, Payment>> getPaymentStatus(String midtransOrderId);
}
