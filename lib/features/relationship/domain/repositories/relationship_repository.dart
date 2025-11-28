import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/relationship/domain/entities/relationship.dart';

abstract class RelationshipRepository {
  Future<Either<Failure, Relationship>> createRelationship(String targetId);
  Future<Either<Failure, List<Relationship>>> getRelationships({
    String? status,
    String? direction,
  });
  Future<Either<Failure, Relationship>> updateRelationshipStatus(
    String id,
    String status,
  );
  Future<Either<Failure, List<PotentialRelationship>>> searchRelationships(
    String role, {
    String? keyword,
  });
  Future<Either<Failure, void>> deleteRelationship(String id);
}


