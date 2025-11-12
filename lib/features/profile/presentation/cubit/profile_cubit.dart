import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/features/profile/domain/entities/profile.dart';
import 'package:temani_frontend/features/profile/domain/repositories/profile_repository.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({required ProfileRepository repository})
      : _repository = repository,
        super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, errorMessage: null));

    final result = await _repository.getProfile();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
        ),
      ),
    );
  }

  Future<void> updateProfile({
    String? name,
    String? username,
    String? dateOfBirth,
    String? email,
    String? phone,
    String? profilePicturePath,
  }) async {
    emit(state.copyWith(
      status: ProfileStatus.saving,
      errorMessage: null,
    ));

    final result = await _repository.updateProfile(
      name: name,
      username: username,
      dateOfBirth: dateOfBirth,
      email: email,
      phone: phone,
      profilePicturePath: profilePicturePath,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (updatedProfile) => emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: updatedProfile,
          selectedImage: null,
          isEditing: false,
        ),
      ),
    );
  }

  void setEditing(bool isEditing) {
    emit(state.copyWith(isEditing: isEditing));
  }

  void setSelectedImage(File? image) {
    emit(state.copyWith(selectedImage: image));
  }

  void cancelEdit() {
    emit(state.copyWith(
      isEditing: false,
      selectedImage: null,
    ));
  }
}

