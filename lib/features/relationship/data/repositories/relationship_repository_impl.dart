import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/relationship/data/datasources/relationship_remote_datasource.dart';
import 'package:temanmu/features/relationship/domain/entities/relationship.dart';
import 'package:temanmu/features/relationship/domain/repositories/relationship_repository.dart';

@Injectable(as: RelationshipRepository)
class RelationshipRepositoryImpl implements RelationshipRepository {
  final RelationshipRemoteDataSource _remoteDataSource;

  RelationshipRepositoryImpl(
      {required RelationshipRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, Relationship>> createRelationship(
      String targetId) async {
    print('[RelationshipRepository] createRelationship called');
    print('[RelationshipRepository] targetId: $targetId');
    
    try {
      print('[RelationshipRepository] Calling remoteDataSource.createRelationship...');
      final result = await _remoteDataSource.createRelationship(targetId);
      print('[RelationshipRepository] RemoteDataSource call completed');
      
      return result.fold(
        (failure) {
          print('[RelationshipRepository] RemoteDataSource returned failure');
          print('[RelationshipRepository] Failure type: ${failure.runtimeType}');
          print('[RelationshipRepository] Failure message: ${failure.message}');
          return Left(failure);
        },
        (response) {
          print('[RelationshipRepository] RemoteDataSource returned success');
          print('[RelationshipRepository] Response status: ${response.status}');
          print('[RelationshipRepository] Response message: ${response.message}');
          print('[RelationshipRepository] Response data: ${response.data}');
          
          if (response.data == null) {
            print('[RelationshipRepository] ERROR: Response data is null!');
            return Left(Failure(message: 'Response data is null'));
          }
          
          print('[RelationshipRepository] Returning relationship: ${response.data!.id}');
          return Right(response.data!);
        },
      );
    } catch (e, stackTrace) {
      print('[RelationshipRepository] Exception in createRelationship: $e');
      print('[RelationshipRepository] Stack trace: $stackTrace');
      return Left(Failure(message: 'Repository error: ${e.toString()}'));
    }
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


