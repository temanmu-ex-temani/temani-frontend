import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/core/environments/_environments.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/counseling/data/models/counseling_schedule_model.dart';

abstract class CounselingScheduleRemoteDataSource {
  Future<Either<Failure, AvailableSchedulesResponse>> getAvailableSchedules();
  Future<Either<Failure, CounselingSchedulesResponse>> getCounselingSchedules({
    List<String>? status,
  });
  Future<Either<Failure, CounselingSchedulesResponse>> getPeerCounselingSchedules();
  Future<Either<Failure, CounselingScheduleModel>> createSchedule({
    required DateTime scheduledAt,
    required String title,
    required String description,
    required String meetingLink,
    required String notes,
  });
  Future<Either<Failure, CounselingScheduleModel>> updateScheduleStatus({
    required String scheduleId,
    required String status,
  });
}

@Injectable(as: CounselingScheduleRemoteDataSource)
class CounselingScheduleRemoteDataSourceImpl
    implements CounselingScheduleRemoteDataSource {
  final Dio dio;

  CounselingScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, AvailableSchedulesResponse>>
  getAvailableSchedules() async {
    return await apiCall<AvailableSchedulesResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.counselingSchedulesAvailable,
      ).then((response) => AvailableSchedulesResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, CounselingSchedulesResponse>> getCounselingSchedules({
    List<String>? status,
  }) async {
    final queryParameters = <String, dynamic>{};

    if (status != null && status.isNotEmpty) {
      // Add multiple status parameters
      for (int i = 0; i < status.length; i++) {
        queryParameters['status'] = status[i];
      }
    }

    print('queryParameters: $queryParameters');
    return await apiCall<CounselingSchedulesResponse>(
      getIt<Map<String, dynamic>>(
        '${EndPoints.counselingSchedules}?status=PENDING&status=SCHEDULED&status=ONGOING&status=COMPLETED&status=CANCELLED',
      ).then(
        (response) => CounselingSchedulesResponse.fromJson(response.data!),
      ),
    );
  }

  @override
  Future<Either<Failure, CounselingSchedulesResponse>> getPeerCounselingSchedules() async {
    print('Calling peer endpoint: ${EndPoints.counselingSchedulesPeer}');
    return await apiCall<CounselingSchedulesResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.counselingSchedulesPeer,
      ).then((response) {
        print('Peer endpoint response received');
        print('Response data type: ${response.data.runtimeType}');
        print('Response data: ${response.data}');
        
        if (response.data == null) {
          throw Exception('Response data is null');
        }
        
        // Handle if response.data is a string (JSON string)
        dynamic jsonData = response.data;
        if (jsonData is String) {
          jsonData = json.decode(jsonData);
        }
        
        final parsed = CounselingSchedulesResponse.fromJson(jsonData as Map<String, dynamic>);
        print('Parsed ${parsed.data.length} sessions');
        return parsed;
      }),
    );
  }

  @override
  Future<Either<Failure, CounselingScheduleModel>> createSchedule({
    required DateTime scheduledAt,
    required String title,
    required String description,
    required String meetingLink,
    required String notes,
  }) async {
    print('Creating schedule: $title at $scheduledAt');
    
    final body = {
      'scheduledAt': scheduledAt.toIso8601String(),
      'title': title,
      'description': description,
      'meetingLink': meetingLink,
      'notes': notes,
    };
    
    print('Request body: $body');
    
    return await apiCall<CounselingScheduleModel>(
      postIt<Map<String, dynamic>>(
        EndPoints.counselingSchedules,
        model: body,
      ).then((response) {
        print('Create schedule response received');
        print('Response data: ${response.data}');
        
        if (response.data == null) {
          throw Exception('Response data is null');
        }
        
        // Handle if response.data is a string (JSON string)
        dynamic jsonData = response.data;
        if (jsonData is String) {
          jsonData = json.decode(jsonData);
        }
        
        // Extract data from response if wrapped
        Map<String, dynamic> scheduleData;
        if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            scheduleData = jsonData['data'] as Map<String, dynamic>;
          } else {
            scheduleData = jsonData;
          }
        } else {
          throw Exception('Invalid response format');
        }
        
        return CounselingScheduleModel.fromJson(scheduleData);
      }),
    );
  }

  @override
  Future<Either<Failure, CounselingScheduleModel>> updateScheduleStatus({
    required String scheduleId,
    required String status,
  }) async {
    print('Updating schedule $scheduleId status to $status');

    final body = {
      'status': status,
    };

    print('Request body: $body');

    return await apiCall<CounselingScheduleModel>(
      patchIt<Map<String, dynamic>>(
        EndPoints.counselingScheduleStatus(scheduleId),
        model: body,
      ).then((response) {
        print('Update status response received');
        print('Response data: ${response.data}');

        if (response.data == null) {
          throw Exception('Response data is null');
        }

        // Handle if response.data is a string (JSON string)
        dynamic jsonData = response.data;
        if (jsonData is String) {
          jsonData = json.decode(jsonData);
        }

        // Extract data from response if wrapped
        Map<String, dynamic> scheduleData;
        if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data')) {
            scheduleData = jsonData['data'] as Map<String, dynamic>;
          } else {
            scheduleData = jsonData;
          }
        } else {
          throw Exception('Invalid response format');
        }

        return CounselingScheduleModel.fromJson(scheduleData);
      }),
    );
  }
}
