import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/counseling/domain/entities/payment.dart';
import 'package:temanmu/features/counseling/domain/entities/payment_request.dart';

abstract class PaymentRepository {
  Future<Either<Failure, Payment>> createPayment(PaymentRequest request);
  Future<Either<Failure, Payment>> getPaymentStatus(String midtransOrderId);
}
