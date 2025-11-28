import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/core/environments/_environments.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileResponse>> getProfile();
  Future<Either<Failure, ProfileResponse>> updateProfile({
    UpdateProfileRequest? profileData,
    File? profilePicture,
  });
}

@Injectable(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    return await apiCall<ProfileResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.profileMe,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return ProfileResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, ProfileResponse>> updateProfile({
    UpdateProfileRequest? profileData,
    File? profilePicture,
  }) async {
    final formData = FormData();

    // Add profile data as JSON string if provided
    if (profileData != null) {
      final profileJson = profileData.toJson();
      if (profileJson.isNotEmpty) {
        formData.fields.add(
          MapEntry('profile', json.encode(profileJson)),
        );
      }
    }

    // Add profile picture if provided
    if (profilePicture != null) {
      final fileName = profilePicture.path.split('/').last;
      formData.files.add(
        MapEntry(
          'profilePicture',
          await MultipartFile.fromFile(
            profilePicture.path,
            filename: fileName,
          ),
        ),
      );
    }

    return await apiCall<ProfileResponse>(
      putMultipartIt<Map<String, dynamic>>(
        EndPoints.profileMe,
        formData: formData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return ProfileResponse.fromJson(data);
      }),
    );
  }
}

