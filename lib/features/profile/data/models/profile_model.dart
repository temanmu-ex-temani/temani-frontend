import 'package:temanmu/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.name,
    required super.username,
    super.dateOfBirth,
    required super.email,
    super.phone,
    required super.createdAt,
    required super.updatedAt,
    required super.verified,
    super.profilePicture,
    required super.roles,
    super.clientProfile,
    super.caregiverProfile,
    super.peerProfile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String?,
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      verified: json['verified'] as bool? ?? false,
      profilePicture: json['profilePicture'] as String?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((item) => Role(
                    id: item['id'] as String? ?? '',
                    name: item['name'] as String? ?? '',
                  ))
              .toList() ??
          [],
      clientProfile: json['clientProfile'] != null
          ? ClientProfile(
              id: json['clientProfile']['id'] as String? ?? '',
              emergencyContact:
                  json['clientProfile']['emergencyContact'] as String?,
              medicalHistory: json['clientProfile']['medicalHistory'] as String?,
              medications: json['clientProfile']['medications'] as String?,
            )
          : null,
      caregiverProfile: json['caregiverProfile'] != null
          ? CaregiverProfile(
              id: json['caregiverProfile']['id'] as String? ?? '',
              qualifications:
                  json['caregiverProfile']['qualifications'] as String?,
            )
          : null,
      peerProfile: json['peerProfile'] != null
          ? PeerProfile(
              id: json['peerProfile']['id'] as String? ?? '',
              specialization: json['peerProfile']['specialization'] as String?,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'verified': verified,
      'profilePicture': profilePicture,
      'roles': roles.map((role) => {'id': role.id, 'name': role.name}).toList(),
      'clientProfile': clientProfile != null
          ? {
              'id': clientProfile!.id,
              'emergencyContact': clientProfile!.emergencyContact,
              'medicalHistory': clientProfile!.medicalHistory,
              'medications': clientProfile!.medications,
            }
          : null,
      'caregiverProfile': caregiverProfile != null
          ? {
              'id': caregiverProfile!.id,
              'qualifications': caregiverProfile!.qualifications,
            }
          : null,
      'peerProfile': peerProfile != null
          ? {
              'id': peerProfile!.id,
              'specialization': peerProfile!.specialization,
            }
          : null,
    };
  }
}

class ProfileResponse {
  final int status;
  final String message;
  final ProfileModel? data;
  final String timestamp;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ProfileModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class UpdateProfileRequest {
  final String? name;
  final String? username;
  final String? dateOfBirth;
  final String? email;
  final String? phone;

  UpdateProfileRequest({
    this.name,
    this.username,
    this.dateOfBirth,
    this.email,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (name != null) json['name'] = name;
    if (username != null) json['username'] = username;
    if (dateOfBirth != null) json['dateOfBirth'] = dateOfBirth;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;
    return json;
  }
}

