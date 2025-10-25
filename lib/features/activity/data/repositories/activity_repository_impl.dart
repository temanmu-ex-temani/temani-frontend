import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/activity/data/datasources/activity_remote_datasource.dart';
import 'package:temani_frontend/features/activity/domain/entities/activity.dart';
import 'package:temani_frontend/features/activity/domain/repositories/activity_repository.dart';

@Injectable(as: ActivityRepository)
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource _remoteDataSource;

  ActivityRepositoryImpl({required ActivityRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Activity>>> getAllActivities() async {
    final result = await _remoteDataSource.getAllActivities();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivitiesByFeature(String feature) async {
    final result = await _remoteDataSource.getActivitiesByFeature(feature);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, List<Activity>>> createTestActivity() async {
    final result = await _remoteDataSource.createTestActivity();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }
}
