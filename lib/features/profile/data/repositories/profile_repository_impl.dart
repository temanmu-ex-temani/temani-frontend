import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:temani_frontend/features/profile/data/models/profile_model.dart';
import 'package:temani_frontend/features/profile/domain/entities/profile.dart';
import 'package:temani_frontend/features/profile/domain/repositories/profile_repository.dart';

@Injectable(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    final result = await _remoteDataSource.getProfile();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, Profile>> updateProfile({
    String? name,
    String? username,
    String? dateOfBirth,
    String? email,
    String? phone,
    String? profilePicturePath,
  }) async {
    final profileData = UpdateProfileRequest(
      name: name,
      username: username,
      dateOfBirth: dateOfBirth,
      email: email,
      phone: phone,
    );

    File? profilePicture;
    if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
      profilePicture = File(profilePicturePath);
    }

    final result = await _remoteDataSource.updateProfile(
      profileData: profileData,
      profilePicture: profilePicture,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }
}

