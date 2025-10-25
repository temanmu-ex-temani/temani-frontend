import 'package:either_dart/either.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/mood/domain/entities/mood_log.dart';
import 'package:temani_frontend/features/mood/domain/entities/mood_summary.dart';

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
}
