import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/mood/data/datasources/mood_remote_datasource.dart';
import 'package:temanmu/features/mood/domain/entities/mood_log.dart';
import 'package:temanmu/features/mood/domain/entities/mood_summary.dart';
import 'package:temanmu/features/mood/domain/repositories/mood_repository.dart';

@Injectable(as: MoodRepository)
class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource _remoteDataSource;

  MoodRepositoryImpl({required MoodRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<MoodLog>>> getAllMoodLogs() async {
    final result = await _remoteDataSource.getAllMoodLogs();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, MoodLog>> createMoodLog({
    required String moodVisual,
    required int emotionScale,
  }) async {
    final result = await _remoteDataSource.createMoodLog(
      moodVisual: moodVisual,
      emotionScale: emotionScale,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, MoodLog>> updateMoodLog({
    required String id,
    required String moodVisual,
    required int emotionScale,
  }) async {
    final result = await _remoteDataSource.updateMoodLog(
      id: id,
      moodVisual: moodVisual,
      emotionScale: emotionScale,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, void>> deleteMoodLog(String id) async {
    final result = await _remoteDataSource.deleteMoodLog(id);
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, MoodSummary>> getMoodSummary({
    String? weekStart,
  }) async {
    final result = await _remoteDataSource.getMoodSummary(weekStart: weekStart);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, MoodSummary>> getMoodSummaryByUserId(
    String userId, {
    String? weekStart,
  }) async {
    final result = await _remoteDataSource.getMoodSummaryByUserId(
      userId,
      weekStart: weekStart,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }
}
