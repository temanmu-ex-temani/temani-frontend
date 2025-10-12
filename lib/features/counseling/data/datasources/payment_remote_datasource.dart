import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/client/_client.dart';
import 'package:temani_frontend/core/environments/_environments.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/data/models/payment_model.dart';

abstract class PaymentRemoteDataSource {
  Future<Either<Failure, PaymentResponseModel>> createPayment(
    PaymentRequestModel request,
  );
  Future<Either<Failure, PaymentResponseModel>> getPaymentStatus(
    String midtransOrderId,
  );
}

@Injectable(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, PaymentResponseModel>> createPayment(
    PaymentRequestModel request,
  ) async {
    return await apiCall<PaymentResponseModel>(
      postIt<Map<String, dynamic>>(
        EndPoints.paymentCreate,
        model: request.toJson(),
      ).then((response) => PaymentResponseModel.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, PaymentResponseModel>> getPaymentStatus(
    String midtransOrderId,
  ) async {
    return await apiCall<PaymentResponseModel>(
      getIt<Map<String, dynamic>>(
        '${EndPoints.paymentStatus}/$midtransOrderId',
      ).then((response) => PaymentResponseModel.fromJson(response.data!)),
    );
  }
}
