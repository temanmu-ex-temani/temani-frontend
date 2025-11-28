import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/bases/widgets/temani_button.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/profile/domain/entities/profile.dart';
import 'package:temanmu/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:temanmu/features/relationship/presentation/cubit/relationship_cubit.dart';
import 'package:temanmu/features/relationship/domain/entities/relationship.dart'
    as relationship_entity;
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:temanmu/services/toast_service.dart';
import 'package:temanmu/services/router_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controllers
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load profile and relationships after the first frame when BlocProvider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().loadProfile();
        // Load relationships if user is a client
        final roles = SharedPreferencesService.getStringList(
          PreferencesKeys.roles,
        );
        if (roles != null && roles.contains('CLIENT')) {
          context.read<RelationshipCubit>().loadAcceptedRelationships();
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _initializeControllers(Profile profile) {
    _nameController.text = profile.name;
    _usernameController.text = profile.username;
    _emailController.text = profile.email;
    _phoneController.text = profile.phone ?? '';
    _dateOfBirthController.text = profile.dateOfBirth ?? '';
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        context.read<ProfileCubit>().setSelectedImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ToastService.show(context, 'Gagal memilih gambar: ${e.toString()}');
      }
    }
  }

  Future<void> _saveProfile() async {
    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;

    if (!state.isEditing) {
      cubit.setEditing(true);
      return;
    }

    final profileData = <String, String?>{};
    if (_nameController.text.trim().isNotEmpty &&
        _nameController.text != state.profile?.name) {
      profileData['name'] = _nameController.text.trim();
    }
    if (_usernameController.text.trim().isNotEmpty &&
        _usernameController.text != state.profile?.username) {
      profileData['username'] = _usernameController.text.trim();
    }
    if (_emailController.text.trim().isNotEmpty &&
        _emailController.text != state.profile?.email) {
      profileData['email'] = _emailController.text.trim();
    }
    if (_phoneController.text.trim().isNotEmpty &&
        _phoneController.text != state.profile?.phone) {
      profileData['phone'] = _phoneController.text.trim();
    }
    if (_dateOfBirthController.text.trim().isNotEmpty &&
        _dateOfBirthController.text != state.profile?.dateOfBirth) {
      profileData['dateOfBirth'] = _dateOfBirthController.text.trim();
    }

    String? profilePicturePath;
    if (state.selectedImage != null) {
      profilePicturePath = state.selectedImage!.path;
    }

    // Check if there's anything to update
    if (profileData.isEmpty && profilePicturePath == null) {
      cubit.setEditing(false);
      if (mounted) {
        ToastService.show(context, 'Tidak ada perubahan untuk disimpan');
      }
      return;
    }

    await cubit.updateProfile(
      name: profileData['name'],
      username: profileData['username'],
      dateOfBirth: profileData['dateOfBirth'],
      email: profileData['email'],
      phone: profileData['phone'],
      profilePicturePath: profilePicturePath,
    );

    // Update display name in SharedPreferences if name changed
    if (profileData.containsKey('name') && state.profile != null) {
      await SharedPreferencesService.saveString(
        PreferencesKeys.displayName,
        profileData['name']!,
      );
    }

    if (!mounted) return;
    final updatedState = cubit.state;
    if (updatedState.status == ProfileStatus.success) {
      ToastService.show(context, 'Profil berhasil diperbarui');
    } else if (updatedState.status == ProfileStatus.error &&
        updatedState.errorMessage != null) {
      ToastService.show(context, updatedState.errorMessage!);
    }
  }

  Future<void> _selectDate() async {
    final state = context.read<ProfileCubit>().state;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          state.profile?.dateOfBirth != null
              ? DateTime.tryParse(state.profile!.dateOfBirth!) ?? DateTime.now()
              : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: BaseColors.info.shade600,
            onPrimary: Colors.white,
            onSurface: Colors.black,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _cancelEdit() {
    final cubit = context.read<ProfileCubit>();
    final profile = cubit.state.profile;
    if (profile != null) {
      _initializeControllers(profile);
    }
    cubit.cancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // Initialize controllers when profile is loaded
        if (state.status == ProfileStatus.success &&
            state.profile != null &&
            _nameController.text.isEmpty) {
          _initializeControllers(state.profile!);
        }

        // Show error message
        if (state.status == ProfileStatus.error && state.errorMessage != null) {
          ToastService.show(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        Widget content;

        if (state.status == ProfileStatus.loading && state.profile == null) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state.status == ProfileStatus.error &&
            state.profile == null) {
          content = Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state.errorMessage ?? 'Gagal memuat profil',
                  style: FontTheme.textRegular,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<ProfileCubit>().loadProfile(),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        } else if (state.profile == null) {
          content = const Center(child: Text('Data profil tidak tersedia'));
        } else {
          final profile = state.profile!;
          content = SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: BaseColors.borderLight,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child:
                              state.selectedImage != null
                                  ? Image.file(
                                    state.selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : profile.profilePicture != null
                                  ? Image.network(
                                    profile.profilePicture!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: BaseColors.neutral.shade100,
                                        child: Icon(
                                          PhosphorIcons.user(),
                                          size: 60,
                                          color: BaseColors.textSecondary,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    color: BaseColors.neutral.shade100,
                                    child: Icon(
                                      PhosphorIcons.user(),
                                      size: 60,
                                      color: BaseColors.textSecondary,
                                    ),
                                  ),
                        ),
                      ),
                      if (state.isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: BaseColors.info,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Profile Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: BaseColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Informasi Profil', style: FontTheme.bodyBold),
                          if (!state.isEditing)
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.pencil(),
                                size: 20,
                                color: BaseColors.info,
                              ),
                              onPressed: () {
                                context.read<ProfileCubit>().setEditing(true);
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'Nama',
                        controller: _nameController,
                        icon: PhosphorIcons.user(),
                        enabled: state.isEditing,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Username',
                        controller: _usernameController,
                        icon: PhosphorIcons.at(),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Email',
                        controller: _emailController,
                        icon: PhosphorIcons.envelope(),
                        enabled: state.isEditing,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Nomor Telepon',
                        controller: _phoneController,
                        icon: PhosphorIcons.phone(),
                        enabled: state.isEditing,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Tanggal Lahir',
                        controller: _dateOfBirthController,
                        icon: PhosphorIcons.calendar(),
                        enabled: state.isEditing,
                        readOnly: true,
                        onTap: state.isEditing ? _selectDate : null,
                      ),
                      if (state.isEditing) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    state.status == ProfileStatus.saving
                                        ? null
                                        : _cancelEdit,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: BorderSide(
                                    color: BaseColors.borderMedium,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  'Batal',
                                  style: FontTheme.textSemiBold.copyWith(
                                    color: BaseColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TemaniButton(
                                type: 3,
                                text:
                                    state.status == ProfileStatus.saving
                                        ? 'Menyimpan...'
                                        : 'Simpan Perubahan',
                                onPressed:
                                    state.status == ProfileStatus.saving
                                        ? null
                                        : _saveProfile,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Relationship Management Button
                BlocBuilder<RelationshipCubit, RelationshipState>(
                  builder: (context, relationshipState) {
                    final roles = SharedPreferencesService.getStringList(
                      PreferencesKeys.roles,
                    );
                    final isClient = roles != null &&
                        (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT'));
                    final isCaregiver = roles != null &&
                        (roles.contains('CAREGIVER') || roles.contains('ROLE_CAREGIVER'));

                    if (!isClient && !isCaregiver) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: BaseColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Kelola Relasi', style: FontTheme.bodyBold),
                              Icon(
                                PhosphorIcons.users(),
                                size: 20,
                                color: BaseColors.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isClient
                                ? 'Kelola hubungan dengan caregiver Anda'
                                : 'Kelola hubungan dengan klien Anda',
                            style: FontTheme.textRegular.copyWith(
                              color: BaseColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: TemaniButton(
                              type: 3,
                              text: 'Buka Kelola Relasi',
                              onPressed: () {
                                router.push('/relationship');
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Relation Section (for clients) - Keep existing relation display
                BlocBuilder<RelationshipCubit, RelationshipState>(
                  builder: (context, relationshipState) {
                    final roles = SharedPreferencesService.getStringList(
                      PreferencesKeys.roles,
                    );
                    final isClient = roles != null &&
                        (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT'));

                    if (!isClient) {
                      return const SizedBox.shrink();
                    }

                    final relationships =
                        relationshipState.acceptedRelationships;
                    final currentUserId = SharedPreferencesService.getString(
                      PreferencesKeys.userId,
                    );

                    // Find the relationship where current user is the client
                    relationship_entity.Relationship? relationship;
                    if (relationships.isNotEmpty) {
                      try {
                        relationship = relationships.firstWhere(
                          (rel) => rel.clientId == currentUserId,
                        );
                      } catch (e) {
                        // If no match found, use the first relationship
                        relationship = relationships.first;
                      }
                    }

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: BaseColors.borderLight,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Relasi', style: FontTheme.bodyBold),
                          const SizedBox(height: 16),
                          if (relationshipState.status ==
                              RelationshipCubitStatus.loading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (relationship != null)
                            _buildRelationshipInfo(relationship)
                          else
                            Text(
                              'Belum terhubung dengan caregiver',
                              style: FontTheme.textRegular.copyWith(
                                color: BaseColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: TemaniButton(
                    type: 2, // Secondary button style
                    text: 'Logout',
                    onPressed: () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: BaseColors.error.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  PhosphorIcons.signOut(),
                                  size: 32,
                                  color: BaseColors.error.shade600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Title
                              Text(
                                'Logout',
                                style: FontTheme.bodyBold.copyWith(
                                  fontSize: 20,
                                  color: BaseColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Message
                              Text(
                                'Apakah Anda yakin ingin keluar?',
                                textAlign: TextAlign.center,
                                style: FontTheme.textRegular.copyWith(
                                  color: BaseColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        side: BorderSide(
                                          color: BaseColors.borderMedium,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        'Batal',
                                        style: FontTheme.textSemiBold.copyWith(
                                          color: BaseColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: BaseColors.error.shade600,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'Logout',
                                        style: FontTheme.textSemiBold.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    if (shouldLogout == true) {
                      // Clear credentials
                      await SharedPreferencesService.removeCreds();
                      
                      // Navigate to login page
                      if (mounted) {
                        router.go('/');
                      }
                    }
                  },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.00, -1.00),
                end: const Alignment(0.00, 1.00),
                colors: [
                  BaseColors.info.shade50,
                  BaseColors.cyan.shade50,
                  BaseColors.success.shade50,
                ],
                stops: const [0, 0.5, 1],
                transform: GradientRotation(169 * 3.14159 / 180),
              ),
            ),
            child: SafeArea(child: content),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    bool readOnly = false,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FontTheme.textSemiBold.copyWith(
            fontSize: 12,
            color: BaseColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          keyboardType: keyboardType,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: 'Masukkan $label',
            hintStyle: FontTheme.textRegular.copyWith(
              color: const Color(0xFFB0B0B0),
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: enabled ? BaseColors.info : BaseColors.textTertiary,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE3EAF2),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFFE3EAF2),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF4B9EFF), width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: BaseColors.borderLight, width: 1.5),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : BaseColors.neutral.shade50,
          ),
          style: FontTheme.textRegular,
        ),
      ],
    );
  }

  Widget _buildRelationshipInfo(relationship_entity.Relationship relationship) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(PhosphorIcons.userCircle(), size: 20, color: BaseColors.info),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caregiver',
                style: FontTheme.textSemiBold.copyWith(
                  fontSize: 12,
                  color: BaseColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                relationship.caregiverName ?? 'Caregiver',
                style: FontTheme.bodySemiBold,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      relationship.accepted
                          ? BaseColors.success.shade100
                          : BaseColors.warning.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        relationship.accepted
                            ? BaseColors.success.shade200
                            : BaseColors.warning.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  relationship.accepted ? 'Terhubung' : 'Menunggu konfirmasi',
                  style: FontTheme.textSemiBold.copyWith(
                    fontSize: 12,
                    color:
                        relationship.accepted
                            ? BaseColors.success.shade700
                            : BaseColors.warning.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
