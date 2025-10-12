import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/client/_client.dart';
import 'package:temani_frontend/core/environments/_environments.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/data/models/counseling_schedule_model.dart';

abstract class CounselingScheduleRemoteDataSource {
  Future<Either<Failure, AvailableSchedulesResponse>> getAvailableSchedules();
}

@Injectable(as: CounselingScheduleRemoteDataSource)
class CounselingScheduleRemoteDataSourceImpl
    implements CounselingScheduleRemoteDataSource {
  final Dio dio;

  CounselingScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, AvailableSchedulesResponse>>
  getAvailableSchedules() async {
    return await apiCall<AvailableSchedulesResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.counselingSchedulesAvailable,
      ).then((response) => AvailableSchedulesResponse.fromJson(response.data!)),
    );
  }
}
