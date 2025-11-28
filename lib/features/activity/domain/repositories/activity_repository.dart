import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/activity/domain/entities/activity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<Activity>>> getAllActivities();
  Future<Either<Failure, List<Activity>>> getActivitiesByFeature(String feature);
  Future<Either<Failure, List<Activity>>> getActivitiesByUserId(String userId);
  Future<Either<Failure, List<Activity>>> createTestActivity();
}
