import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/bases/widgets/temanmu_button.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/relationship/domain/entities/relationship.dart';
import 'package:temanmu/features/relationship/presentation/cubit/relationship_cubit.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:temanmu/services/toast_service.dart';
import 'package:intl/intl.dart';

class RelationshipPage extends StatefulWidget {
  const RelationshipPage({super.key});

  @override
  State<RelationshipPage> createState() => _RelationshipPageState();
}

class _RelationshipPageState extends State<RelationshipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late RelationshipCubit _cubit;
  final TextEditingController _searchController = TextEditingController();
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _cubit = get<RelationshipCubit>();
    _determineUserRole();
    _loadInitialData();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      // When search tab is selected, load potential relationships
      if (_tabController.index == 3) {
        _cubit.searchPotentialRelationships(_searchRole);
      }
    }
  }

  void _determineUserRole() {
    final roles = SharedPreferencesService.getStringList(PreferencesKeys.roles);
    if (roles != null) {
      if (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT')) {
        _userRole = 'CLIENT';
      } else if (roles.contains('CAREGIVER') || roles.contains('ROLE_CAREGIVER')) {
        _userRole = 'CAREGIVER';
      }
    }
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadAllRelationships();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String get _searchRole {
    // If user is CLIENT, search for CAREGIVER
    // If user is CAREGIVER, search for CLIENT
    return _userRole == 'CLIENT' ? 'CAREGIVER' : 'CLIENT';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<RelationshipCubit, RelationshipState>(
        listener: (context, state) {
          print('[RelationshipPage] BlocListener - State changed');
          print('[RelationshipPage] Status: ${state.status}');
          print('[RelationshipPage] Error message: ${state.errorMessage}');
          
          if (state.status == RelationshipCubitStatus.error &&
              state.errorMessage != null) {
            print('[RelationshipPage] Showing error toast: ${state.errorMessage}');
            ToastService.show(context, state.errorMessage!);
          }
          
          if (state.status == RelationshipCubitStatus.success) {
            print('[RelationshipPage] Operation successful');
          }
        },
        child: Scaffold(
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
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                          color: Colors.black,
                        ),
                        Expanded(
                          child: Text(
                            'Kelola Relasi',
                            style: FontTheme.subHeader,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),
                  // Tabs
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: BaseColors.info.shade600,
                      labelColor: BaseColors.info.shade600,
                      unselectedLabelColor: BaseColors.textSecondary,
                      labelStyle: FontTheme.textSemiBold.copyWith(fontSize: 12),
                      unselectedLabelStyle:
                          FontTheme.textRegular.copyWith(fontSize: 12),
                      tabs: const [
                        Tab(text: 'Terhubung'),
                        Tab(text: 'Menunggu'),
                        Tab(text: 'Permintaan'),
                        Tab(text: 'Cari'),
                      ],
                    ),
                  ),
                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAcceptedTab(),
                        _buildPendingSentTab(),
                        _buildPendingReceivedTab(),
                        _buildSearchTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptedTab() {
    return BlocBuilder<RelationshipCubit, RelationshipState>(
      builder: (context, state) {
        if (state.status == RelationshipCubitStatus.loading &&
            state.acceptedRelationships.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.acceptedRelationships.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.users(),
                  size: 64,
                  color: BaseColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada relasi yang terhubung',
                  style: FontTheme.textMedium.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.acceptedRelationships.length,
          itemBuilder: (context, index) {
            final relationship = state.acceptedRelationships[index];
            return _buildAcceptedRelationshipCard(relationship);
          },
        );
      },
    );
  }

  Widget _buildPendingSentTab() {
    return BlocBuilder<RelationshipCubit, RelationshipState>(
      builder: (context, state) {
        if (state.status == RelationshipCubitStatus.loading &&
            state.pendingSentRelationships.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.pendingSentRelationships.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.clock(),
                  size: 64,
                  color: BaseColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada permintaan yang dikirim',
                  style: FontTheme.textMedium.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.pendingSentRelationships.length,
          itemBuilder: (context, index) {
            final relationship = state.pendingSentRelationships[index];
            return _buildPendingSentRelationshipCard(relationship);
          },
        );
      },
    );
  }

  Widget _buildPendingReceivedTab() {
    return BlocBuilder<RelationshipCubit, RelationshipState>(
      builder: (context, state) {
        if (state.status == RelationshipCubitStatus.loading &&
            state.pendingReceivedRelationships.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.pendingReceivedRelationships.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  PhosphorIcons.bell(),
                  size: 64,
                  color: BaseColors.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada permintaan masuk',
                  style: FontTheme.textMedium.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.pendingReceivedRelationships.length,
          itemBuilder: (context, index) {
            final relationship = state.pendingReceivedRelationships[index];
            return _buildPendingReceivedRelationshipCard(relationship);
          },
        );
      },
    );
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari ${_userRole == 'CLIENT' ? 'caregiver' : 'klien'}...',
                hintStyle: FontTheme.textRegular.copyWith(
                  color: BaseColors.textTertiary,
                ),
                prefixIcon: Icon(
                  PhosphorIcons.magnifyingGlass(),
                  color: BaseColors.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          PhosphorIcons.x(),
                          color: BaseColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _cubit.searchPotentialRelationships(_searchRole);
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: FontTheme.textRegular,
              onChanged: (value) {
                setState(() {});
                if (value.isEmpty) {
                  _cubit.searchPotentialRelationships(_searchRole);
                } else {
                  _cubit.searchPotentialRelationships(_searchRole, keyword: value);
                }
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _cubit.searchPotentialRelationships(_searchRole, keyword: value);
                }
              },
            ),
          ),
        ),
        // Search Results
        Expanded(
          child: BlocBuilder<RelationshipCubit, RelationshipState>(
            builder: (context, state) {
              if (state.status == RelationshipCubitStatus.loading &&
                  state.potentialRelationships.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.potentialRelationships.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIcons.users(),
                        size: 64,
                        color: BaseColors.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty
                            ? 'Mulai mencari untuk menemukan ${_userRole == 'CLIENT' ? 'caregiver' : 'klien'}'
                            : 'Tidak ada hasil ditemukan',
                        style: FontTheme.textMedium.copyWith(
                          color: BaseColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.potentialRelationships.length,
                itemBuilder: (context, index) {
                  final potential = state.potentialRelationships[index];
                  return _buildPotentialRelationshipCard(potential);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAcceptedRelationshipCard(Relationship relationship) {
    final isCaregiver = _userRole == 'CAREGIVER';
    final otherPersonName = isCaregiver
        ? (relationship.clientName ?? 'Client')
        : (relationship.caregiverName ?? 'Caregiver');
    final otherPersonRole = isCaregiver ? 'Klien' : 'Caregiver';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: BaseColors.success.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.user(),
              color: BaseColors.success.shade600,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherPersonName,
                  style: FontTheme.bodyBold,
                ),
                const SizedBox(height: 4),
                Text(
                  otherPersonRole,
                  style: FontTheme.textRegular.copyWith(
                    color: BaseColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Terhubung sejak ${DateFormat('dd MMM yyyy').format(relationship.createdAt)}',
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (isCaregiver)
            IconButton(
              icon: Icon(
                PhosphorIcons.trash(),
                color: BaseColors.error.shade600,
              ),
              onPressed: () => _showDeleteDialog(relationship.id),
            ),
        ],
      ),
    );
  }

  Widget _buildPendingSentRelationshipCard(Relationship relationship) {
    final isCaregiver = _userRole == 'CAREGIVER';
    final otherPersonName = isCaregiver
        ? (relationship.clientName ?? 'Client')
        : (relationship.caregiverName ?? 'Caregiver');
    final otherPersonRole = isCaregiver ? 'Klien' : 'Caregiver';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: BaseColors.warning.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.clock(),
              color: BaseColors.warning.shade600,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherPersonName,
                  style: FontTheme.bodyBold,
                ),
                const SizedBox(height: 4),
                Text(
                  otherPersonRole,
                  style: FontTheme.textRegular.copyWith(
                    color: BaseColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Menunggu konfirmasi',
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.warning.shade600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showCancelDialog(relationship.id),
            child: Text(
              'Batal',
              style: FontTheme.textSemiBold.copyWith(
                color: BaseColors.error.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReceivedRelationshipCard(Relationship relationship) {
    final isCaregiver = _userRole == 'CAREGIVER';
    final otherPersonName = isCaregiver
        ? (relationship.clientName ?? 'Client')
        : (relationship.caregiverName ?? 'Caregiver');
    final otherPersonRole = isCaregiver ? 'Klien' : 'Caregiver';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: BaseColors.info.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.bell(),
                  color: BaseColors.info.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherPersonName,
                      style: FontTheme.bodyBold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      otherPersonRole,
                      style: FontTheme.textRegular.copyWith(
                        color: BaseColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingin terhubung dengan Anda',
                      style: FontTheme.captionRegular.copyWith(
                        color: BaseColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showRejectDialog(relationship.id),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color: BaseColors.error.shade600,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'Tolak',
                    style: FontTheme.textSemiBold.copyWith(
                      color: BaseColors.error.shade600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TemanMuButton(
                  type: 3,
                  text: 'Terima',
                  onPressed: () => _acceptRelationship(relationship.id),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPotentialRelationshipCard(PotentialRelationship potential) {
    final statusText = _getStatusText(potential.relationshipStatus);
    final statusColor = _getStatusColor(potential.relationshipStatus);
    final canSendRequest = potential.relationshipStatus == RelationshipStatus.none;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: BaseColors.info.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.user(),
              color: BaseColors.info.shade600,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  potential.name,
                  style: FontTheme.bodyBold,
                ),
                const SizedBox(height: 4),
                Text(
                  '@${potential.username}',
                  style: FontTheme.textRegular.copyWith(
                    color: BaseColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusText,
                    style: FontTheme.captionMedium.copyWith(
                      color: statusColor,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (canSendRequest)
            TemanMuButton(
              type: 3,
              text: 'Kirim',
              onPressed: () => _createRelationship(potential.userId),
            ),
        ],
      ),
    );
  }

  String _getStatusText(RelationshipStatus status) {
    switch (status) {
      case RelationshipStatus.none:
        return 'Tersedia';
      case RelationshipStatus.sent:
        return 'Terkirim';
      case RelationshipStatus.received:
        return 'Diterima';
      case RelationshipStatus.connected:
        return 'Terhubung';
      case RelationshipStatus.connectedToOther:
        return 'Terhubung ke Lain';
    }
  }

  Color _getStatusColor(RelationshipStatus status) {
    switch (status) {
      case RelationshipStatus.none:
        return BaseColors.success.shade600;
      case RelationshipStatus.sent:
        return BaseColors.warning.shade600;
      case RelationshipStatus.received:
        return BaseColors.info.shade600;
      case RelationshipStatus.connected:
        return BaseColors.success.shade600;
      case RelationshipStatus.connectedToOther:
        return BaseColors.error.shade600;
    }
  }

  void _createRelationship(String targetId) {
    print('[RelationshipPage] _createRelationship called');
    print('[RelationshipPage] targetId: $targetId');
    print('[RelationshipPage] userRole: $_userRole');
    print('[RelationshipPage] searchRole: $_searchRole');
    
    _cubit.createRelationship(targetId).then((_) {
      print('[RelationshipPage] createRelationship completed');
      _cubit.loadPendingSentRelationships();
      _cubit.searchPotentialRelationships(_searchRole, keyword: _searchController.text);
    }).catchError((error) {
      print('[RelationshipPage] Error in createRelationship: $error');
      print('[RelationshipPage] Error stack trace: ${error.stackTrace}');
    });
  }

  void _acceptRelationship(String id) {
    _cubit.acceptRelationship(id).then((_) {
      _cubit.loadAllRelationships();
    });
  }

  void _showCancelDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Batalkan Permintaan', style: FontTheme.bodyBold),
        content: Text(
          'Apakah Anda yakin ingin membatalkan permintaan ini?',
          style: FontTheme.textRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: FontTheme.textSemiBold),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cubit.cancelRelationship(id).then((_) {
                _cubit.loadPendingSentRelationships();
              });
            },
            child: Text(
              'Ya, Batalkan',
              style: FontTheme.textSemiBold.copyWith(
                color: BaseColors.error.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Tolak Permintaan', style: FontTheme.bodyBold),
        content: Text(
          'Apakah Anda yakin ingin menolak permintaan ini?',
          style: FontTheme.textRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: FontTheme.textSemiBold),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cubit.rejectRelationship(id).then((_) {
                _cubit.loadPendingReceivedRelationships();
              });
            },
            child: Text(
              'Ya, Tolak',
              style: FontTheme.textSemiBold.copyWith(
                color: BaseColors.error.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Relasi', style: FontTheme.bodyBold),
        content: Text(
          'Apakah Anda yakin ingin menghapus relasi ini?',
          style: FontTheme.textRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: FontTheme.textSemiBold),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cubit.deleteRelationship(id).then((_) {
                _cubit.loadAcceptedRelationships();
              });
            },
            child: Text(
              'Ya, Hapus',
              style: FontTheme.textSemiBold.copyWith(
                color: BaseColors.error.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

