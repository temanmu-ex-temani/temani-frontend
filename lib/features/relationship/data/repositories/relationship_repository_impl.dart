import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/relationship/data/datasources/relationship_remote_datasource.dart';
import 'package:temani_frontend/features/relationship/domain/entities/relationship.dart';
import 'package:temani_frontend/features/relationship/domain/repositories/relationship_repository.dart';

@Injectable(as: RelationshipRepository)
class RelationshipRepositoryImpl implements RelationshipRepository {
  final RelationshipRemoteDataSource _remoteDataSource;

  RelationshipRepositoryImpl(
      {required RelationshipRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, Relationship>> createRelationship(
      String targetId) async {
    final result = await _remoteDataSource.createRelationship(targetId);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, List<Relationship>>> getRelationships({
    String? status,
    String? direction,
  }) async {
    final result = await _remoteDataSource.getRelationships(
      status: status,
      direction: direction,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, Relationship>> updateRelationshipStatus(
    String id,
    String status,
  ) async {
    final result = await _remoteDataSource.updateRelationshipStatus(id, status);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, List<PotentialRelationship>>> searchRelationships(
    String role, {
    String? keyword,
  }) async {
    final result = await _remoteDataSource.searchRelationships(
      role,
      keyword: keyword,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, void>> deleteRelationship(String id) async {
    final result = await _remoteDataSource.deleteRelationship(id);
    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }
}


