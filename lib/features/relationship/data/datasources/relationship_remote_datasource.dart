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
    print('[RelationshipRemoteDataSource] createRelationship called');
    print('[RelationshipRemoteDataSource] targetId: $targetId');
    print('[RelationshipRemoteDataSource] Endpoint: ${EndPoints.relationships}');
    
    final requestData = CreateRelationshipRequest(targetId: targetId).toJson();
    print('[RelationshipRemoteDataSource] Request data: $requestData');
    print('[RelationshipRemoteDataSource] Request data type: ${requestData.runtimeType}');
    
    // Show what will be sent as JSON
    final jsonString = json.encode(requestData);
    print('[RelationshipRemoteDataSource] JSON encoded request: $jsonString');
    print('[RelationshipRemoteDataSource] targetId value: $targetId');
    print('[RelationshipRemoteDataSource] targetId type: ${targetId.runtimeType}');
    print('[RelationshipRemoteDataSource] targetId isEmpty: ${targetId.isEmpty}');
    print('[RelationshipRemoteDataSource] targetId isBlank: ${targetId.trim().isEmpty}');

    try {
      print('[RelationshipRemoteDataSource] Calling postIt...');
      print('[RelationshipRemoteDataSource] Full URL: ${EndPoints.relationships}');
      final response = await postIt<Map<String, dynamic>>(
        EndPoints.relationships,
        model: requestData,
      );
      
      print('[RelationshipRemoteDataSource] postIt completed');
      print('[RelationshipRemoteDataSource] Response status code: ${response.statusCode}');
      print('[RelationshipRemoteDataSource] Response data type: ${response.data.runtimeType}');
      print('[RelationshipRemoteDataSource] Response data: ${response.data}');
      
      if (response.data == null) {
        print('[RelationshipRemoteDataSource] ERROR: Response data is null!');
        return Left(Failure(message: 'Response data is null'));
      }

      final dynamic raw = response.data;
      print('[RelationshipRemoteDataSource] Raw data type: ${raw.runtimeType}');
      
      dynamic data;
      if (raw is String) {
        print('[RelationshipRemoteDataSource] Raw data is String, decoding JSON...');
        data = json.decode(raw);
        print('[RelationshipRemoteDataSource] Decoded data: $data');
      } else {
        print('[RelationshipRemoteDataSource] Raw data is not String, using as is');
        data = raw;
      }
      
      print('[RelationshipRemoteDataSource] Parsing RelationshipResponse from JSON...');
      print('[RelationshipRemoteDataSource] Data to parse: $data');
      print('[RelationshipRemoteDataSource] Data type: ${data.runtimeType}');
      
      try {
        final relationshipResponse = RelationshipResponse.fromJson(data);
        print('[RelationshipRemoteDataSource] Successfully parsed RelationshipResponse');
        print('[RelationshipRemoteDataSource] Response status: ${relationshipResponse.status}');
        print('[RelationshipRemoteDataSource] Response message: ${relationshipResponse.message}');
        print('[RelationshipRemoteDataSource] Response data: ${relationshipResponse.data}');
        
        return Right(relationshipResponse);
      } catch (e, stackTrace) {
        print('[RelationshipRemoteDataSource] ERROR parsing RelationshipResponse: $e');
        print('[RelationshipRemoteDataSource] Stack trace: $stackTrace');
        print('[RelationshipRemoteDataSource] Data that failed to parse: $data');
        return Left(Failure(message: 'Failed to parse response: ${e.toString()}'));
      }
    } catch (e, stackTrace) {
      print('[RelationshipRemoteDataSource] Exception in createRelationship: $e');
      print('[RelationshipRemoteDataSource] Exception type: ${e.runtimeType}');
      print('[RelationshipRemoteDataSource] Stack trace: $stackTrace');
      
      if (e is DioException) {
        print('[RelationshipRemoteDataSource] DioException details:');
        print('[RelationshipRemoteDataSource] - Type: ${e.type}');
        print('[RelationshipRemoteDataSource] - Message: ${e.message}');
        print('[RelationshipRemoteDataSource] - Response: ${e.response}');
        print('[RelationshipRemoteDataSource] - Response data: ${e.response?.data}');
        print('[RelationshipRemoteDataSource] - Response status code: ${e.response?.statusCode}');
        print('[RelationshipRemoteDataSource] - Request path: ${e.requestOptions.path}');
        print('[RelationshipRemoteDataSource] - Request URL: ${e.requestOptions.uri}');
        print('[RelationshipRemoteDataSource] - Request method: ${e.requestOptions.method}');
        print('[RelationshipRemoteDataSource] - Request headers: ${e.requestOptions.headers}');
        print('[RelationshipRemoteDataSource] - Request data: ${e.requestOptions.data}');
        print('[RelationshipRemoteDataSource] - Request data type: ${e.requestOptions.data.runtimeType}');
        
        // Try to parse error response if available
        if (e.response?.data != null) {
          print('[RelationshipRemoteDataSource] - Error response data type: ${e.response!.data.runtimeType}');
          try {
            final errorData = e.response!.data is String 
                ? json.decode(e.response!.data) 
                : e.response!.data;
            print('[RelationshipRemoteDataSource] - Parsed error response: $errorData');
            if (errorData is Map) {
              print('[RelationshipRemoteDataSource] - Error message: ${errorData['message']}');
              print('[RelationshipRemoteDataSource] - Error status: ${errorData['status']}');
            }
          } catch (parseError) {
            print('[RelationshipRemoteDataSource] - Could not parse error response: $parseError');
          }
        }
      }
      
      return Left(Failure(message: 'Network error: ${e.toString()}'));
    }
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

