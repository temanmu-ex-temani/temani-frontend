class Profile {
  final String id;
  final String name;
  final String username;
  final String? dateOfBirth;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool verified;
  final String? profilePicture;
  final List<Role> roles;
  final ClientProfile? clientProfile;
  final CaregiverProfile? caregiverProfile;
  final PeerProfile? peerProfile;

  Profile({
    required this.id,
    required this.name,
    required this.username,
    this.dateOfBirth,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.verified,
    this.profilePicture,
    required this.roles,
    this.clientProfile,
    this.caregiverProfile,
    this.peerProfile,
  });
}

class Role {
  final String id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });
}

class ClientProfile {
  final String id;
  final String? emergencyContact;
  final String? medicalHistory;
  final String? medications;

  ClientProfile({
    required this.id,
    this.emergencyContact,
    this.medicalHistory,
    this.medications,
  });
}

class CaregiverProfile {
  final String id;
  final String? qualifications;

  CaregiverProfile({
    required this.id,
    this.qualifications,
  });
}

class PeerProfile {
  final String id;
  final String? specialization;

  PeerProfile({
    required this.id,
    this.specialization,
  });
}

