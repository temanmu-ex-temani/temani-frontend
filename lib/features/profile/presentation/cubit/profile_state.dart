part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error, saving }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final Profile? profile;
  final String? errorMessage;
  final bool isEditing;
  final File? selectedImage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isEditing = false,
    this.selectedImage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    Profile? profile,
    String? errorMessage,
    bool? isEditing,
    File? selectedImage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditing: isEditing ?? this.isEditing,
      selectedImage: selectedImage ?? this.selectedImage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isEditing, selectedImage];
}

