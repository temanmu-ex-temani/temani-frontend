import 'package:either_dart/either.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Profile>> updateProfile({
    String? name,
    String? username,
    String? dateOfBirth,
    String? email,
    String? phone,
    String? profilePicturePath,
  });
}

