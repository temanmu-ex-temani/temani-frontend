import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/client/_client.dart';
import 'package:temani_frontend/core/environments/_environments.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/relationship/data/models/relationship_model.dart';

abstract class RelationshipRemoteDataSource {
  Future<Either<Failure, RelationshipResponse>> createRelationship(
      String targetId);
  Future<Either<Failure, RelationshipListResponse>> getRelationships({
    String? status,
    String? direction,
  });
  Future<Either<Failure, RelationshipResponse>> updateRelationshipStatus(
    String id,
    String status,
  );
  Future<Either<Failure, PotentialRelationshipListResponse>> searchRelationships(
    String role, {
    String? keyword,
  });
  Future<Either<Failure, void>> deleteRelationship(String id);
}

@Injectable(as: RelationshipRemoteDataSource)
class RelationshipRemoteDataSourceImpl
    implements RelationshipRemoteDataSource {
  final Dio dio;

  RelationshipRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, RelationshipResponse>> createRelationship(
      String targetId) async {
    final requestData = CreateRelationshipRequest(targetId: targetId).toJson();

    return await apiCall<RelationshipResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.relationships,
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return RelationshipResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, RelationshipListResponse>> getRelationships({
    String? status,
    String? direction,
  }) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;
    if (direction != null) queryParams['direction'] = direction;

    return await apiCall<RelationshipListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.relationships,
        queryParameters: queryParams,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return RelationshipListResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, RelationshipResponse>> updateRelationshipStatus(
    String id,
    String status,
  ) async {
    final requestData =
        UpdateRelationshipStatusRequest(status: status).toJson();

    return await apiCall<RelationshipResponse>(
      patchIt<Map<String, dynamic>>(
        EndPoints.relationshipById(id),
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return RelationshipResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, PotentialRelationshipListResponse>>
      searchRelationships(
    String role, {
    String? keyword,
  }) async {
    final queryParams = <String, dynamic>{'role': role};
    if (keyword != null && keyword.isNotEmpty) {
      queryParams['keyword'] = keyword;
    }

    return await apiCall<PotentialRelationshipListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.relationshipsSearch,
        queryParameters: queryParams,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return PotentialRelationshipListResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, void>> deleteRelationship(String id) async {
    return await apiCall<void>(
      deleteIt<Map<String, dynamic>>(
        EndPoints.relationshipById(id),
      ).then((response) => null),
    );
  }
}

