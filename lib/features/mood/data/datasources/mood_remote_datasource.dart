import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/core/environments/_environments.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/mood/data/models/mood_log_model.dart';
import 'package:temanmu/features/mood/data/models/mood_summary_model.dart';

abstract class MoodRemoteDataSource {
  Future<Either<Failure, MoodLogListResponse>> getAllMoodLogs();
  Future<Either<Failure, MoodLogResponse>> createMoodLog({
    required String moodVisual,
    required int emotionScale,
  });
  Future<Either<Failure, MoodLogResponse>> updateMoodLog({
    required String id,
    required String moodVisual,
    required int emotionScale,
  });
  Future<Either<Failure, MoodLogResponse>> deleteMoodLog(String id);
  Future<Either<Failure, MoodSummaryResponse>> getMoodSummary({
    String? weekStart,
  });
  Future<Either<Failure, MoodSummaryResponse>> getMoodSummaryByUserId(
    String userId, {
    String? weekStart,
  });
}

@Injectable(as: MoodRemoteDataSource)
class MoodRemoteDataSourceImpl implements MoodRemoteDataSource {
  final Dio dio;

  MoodRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, MoodLogListResponse>> getAllMoodLogs() async {
    return await apiCall<MoodLogListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.moodLogs,
      ).then((response) => MoodLogListResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, MoodLogResponse>> createMoodLog({
    required String moodVisual,
    required int emotionScale,
  }) async {
    final requestData =
        MoodLogRequest(
          moodVisual: moodVisual,
          emotionScale: emotionScale,
        ).toJson();

    return await apiCall<MoodLogResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.moodLogs,
        model: requestData,
      ).then((response) => MoodLogResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, MoodLogResponse>> updateMoodLog({
    required String id,
    required String moodVisual,
    required int emotionScale,
  }) async {
    final requestData =
        MoodLogRequest(
          moodVisual: moodVisual,
          emotionScale: emotionScale,
        ).toJson();

    return await apiCall<MoodLogResponse>(
      putIt<Map<String, dynamic>>(
        EndPoints.moodLogById(id),
        model: requestData,
      ).then((response) => MoodLogResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, MoodLogResponse>> deleteMoodLog(String id) async {
    return await apiCall<MoodLogResponse>(
      deleteIt<Map<String, dynamic>>(
        EndPoints.moodLogById(id),
      ).then((response) => MoodLogResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, MoodSummaryResponse>> getMoodSummary({
    String? weekStart,
  }) async {
    final queryParams = <String, dynamic>{};
    if (weekStart != null) {
      queryParams['weekStart'] = weekStart;
    }

    return await apiCall<MoodSummaryResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.moodSummary,
        queryParameters: queryParams,
      ).then((response) => MoodSummaryResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, MoodSummaryResponse>> getMoodSummaryByUserId(
    String userId, {
    String? weekStart,
  }) async {
    final queryParams = <String, dynamic>{};
    if (weekStart != null) {
      queryParams['weekStart'] = weekStart;
    }

    return await apiCall<MoodSummaryResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.moodSummaryByUser(userId),
        queryParameters: queryParams,
      ).then((response) => MoodSummaryResponse.fromJson(response.data!)),
    );
  }
}
