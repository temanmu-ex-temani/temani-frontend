import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/mood/domain/entities/mood_log.dart';
import 'package:temanmu/features/mood/domain/entities/mood_summary.dart';

abstract class MoodRepository {
  Future<Either<Failure, List<MoodLog>>> getAllMoodLogs();
  Future<Either<Failure, MoodLog>> createMoodLog({
    required String moodVisual,
    required int emotionScale,
  });
  Future<Either<Failure, MoodLog>> updateMoodLog({
    required String id,
    required String moodVisual,
    required int emotionScale,
  });
  Future<Either<Failure, void>> deleteMoodLog(String id);
  Future<Either<Failure, MoodSummary>> getMoodSummary({String? weekStart});
  Future<Either<Failure, MoodSummary>> getMoodSummaryByUserId(
    String userId, {
    String? weekStart,
  });
}
