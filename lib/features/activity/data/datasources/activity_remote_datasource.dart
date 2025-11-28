import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/core/environments/_environments.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/activity/data/models/activity_model.dart';

abstract class ActivityRemoteDataSource {
  Future<Either<Failure, ActivityListResponse>> getAllActivities();
  Future<Either<Failure, ActivityListResponse>> getActivitiesByFeature(String feature);
  Future<Either<Failure, ActivityListResponse>> getActivitiesByUserId(String userId);
  Future<Either<Failure, ActivityListResponse>> createTestActivity();
}

@Injectable(as: ActivityRemoteDataSource)
class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final Dio dio;

  ActivityRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, ActivityListResponse>> getAllActivities() async {
    return await apiCall<ActivityListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.interactionLogs,
      ).then((response) => ActivityListResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, ActivityListResponse>> getActivitiesByFeature(String feature) async {
    return await apiCall<ActivityListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.interactionLogsByFeature(feature),
      ).then((response) => ActivityListResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, ActivityListResponse>> getActivitiesByUserId(String userId) async {
    return await apiCall<ActivityListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.interactionLogsByUser(userId),
      ).then((response) => ActivityListResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, ActivityListResponse>> createTestActivity() async {
    return await apiCall<ActivityListResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.interactionLogsTest,
      ).then((response) => ActivityListResponse.fromJson(response.data!)),
    );
  }
}
