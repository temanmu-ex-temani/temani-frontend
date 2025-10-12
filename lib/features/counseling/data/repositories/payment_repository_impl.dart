import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/data/datasources/payment_remote_datasource.dart';
import 'package:temani_frontend/features/counseling/data/models/payment_model.dart';
import 'package:temani_frontend/features/counseling/domain/entities/payment.dart';
import 'package:temani_frontend/features/counseling/domain/entities/payment_request.dart';
import 'package:temani_frontend/features/counseling/domain/repositories/payment_repository.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Payment>> createPayment(PaymentRequest request) async {
    final requestModel = PaymentRequestModel(
      scheduleId: request.scheduleId,
      fee: request.fee,
    );

    final result = await remoteDataSource.createPayment(requestModel);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(_mapModelToEntity(response.data)),
    );
  }

  @override
  Future<Either<Failure, Payment>> getPaymentStatus(
    String midtransOrderId,
  ) async {
    final result = await remoteDataSource.getPaymentStatus(midtransOrderId);

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(_mapModelToEntity(response.data)),
    );
  }

  Payment _mapModelToEntity(PaymentModel model) {
    return Payment(
      id: model.id,
      scheduleId: model.scheduleId,
      userId: model.userId,
      midtransOrderId: model.midtransOrderId,
      midtransTransactionId: model.midtransTransactionId,
      amount: model.amount,
      status: model.status,
      paymentMethod: model.paymentMethod,
      paymentType: model.paymentType,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      paidAt: model.paidAt,
      failureReason: model.failureReason,
      redirectUrl: model.redirectUrl,
      token: model.token,
    );
  }
}
