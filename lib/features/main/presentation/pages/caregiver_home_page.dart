import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/activity/domain/entities/activity.dart';
import 'package:temani_frontend/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_filter_buttons.dart';
import 'package:temani_frontend/features/main/presentation/widgets/caregiver_mood_summary.dart';
import 'package:temani_frontend/features/relationship/domain/entities/relationship.dart';
import 'package:temani_frontend/features/relationship/presentation/cubit/relationship_cubit.dart';
import 'package:temani_frontend/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import 'package:temani_frontend/services/shared_preference_service.dart';
import 'package:temani_frontend/core/constants/_constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CaregiverHomePage extends StatefulWidget {
  const CaregiverHomePage({super.key});

  @override
  State<CaregiverHomePage> createState() => _CaregiverHomePageState();
}

class _CaregiverHomePageState extends State<CaregiverHomePage> {
  late final ActivityCubit _activityCubit;
  late final RelationshipCubit _relationshipCubit;
  late final MoodCubit _moodCubit;
  String selectedFeature = 'all';
  String? selectedClientId;
  Map<String, List<Activity>> clientActivities = {};
  Map<String, String> clientNames = {};
  Map<String, Relationship> clientRelationships = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _activityCubit = get<ActivityCubit>();
    _relationshipCubit = get<RelationshipCubit>();
    _moodCubit = get<MoodCubit>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    // Load accepted relationships to get clients
    await _relationshipCubit.loadAcceptedRelationships();

    // Wait for relationships to load
    if (_relationshipCubit.state.acceptedRelationships.isNotEmpty) {
      // Get current user ID to determine if we're the caregiver
      final currentUserId = SharedPreferencesService.getString(
        PreferencesKeys.userId,
      );

      // Find relationships where current user is the caregiver
      final relationships = _relationshipCubit.state.acceptedRelationships
          .where((rel) => rel.caregiverId == currentUserId)
          .toList();

      if (relationships.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Set first client as selected by default
      if (selectedClientId == null && relationships.isNotEmpty) {
        selectedClientId = relationships.first.clientId;
      }

      // Load activities for selected client only
      if (selectedClientId != null) {
        await _loadClientData(selectedClientId!);
      }

      // Build maps for client info
      final Map<String, String> namesMap = {};
      final Map<String, Relationship> relationshipsMap = {};

      for (final relationship in relationships) {
        final clientId = relationship.clientId;
        final clientName = relationship.clientName ?? 'Client';
        namesMap[clientId] = clientName;
        relationshipsMap[clientId] = relationship;
      }

      setState(() {
        clientNames = namesMap;
        clientRelationships = relationshipsMap;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadClientData(String clientId) async {
    // Load activities for this client
    final result = await _activityCubit.loadActivitiesByUserId(clientId);
    result.fold(
      (failure) {
        print('Error loading activities for client $clientId: ${failure.message}');
        setState(() {
          clientActivities[clientId] = [];
        });
      },
      (activities) {
        setState(() {
          clientActivities[clientId] = activities;
        });
      },
    );

    // Load mood summary for this specific client
    _moodCubit.loadMoodSummaryByUserId(clientId);
  }

  void _onClientSelected(String? clientId) {
    if (clientId == null) return;
    
    setState(() {
      selectedClientId = clientId;
    });

    // Load data for selected client if not already loaded
    if (!clientActivities.containsKey(clientId)) {
      _loadClientData(clientId);
    } else {
      // Reload mood summary for selected client
      _moodCubit.loadMoodSummaryByUserId(clientId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _activityCubit),
        BlocProvider.value(value: _relationshipCubit),
        BlocProvider.value(value: _moodCubit),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      'Beranda',
                      style: FontTheme.subHeader,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Client Selector and Content
                  BlocBuilder<RelationshipCubit, RelationshipState>(
                    bloc: _relationshipCubit,
                    builder: (context, relationshipState) {
                      if (isLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (relationshipState.status ==
                          RelationshipCubitStatus.loading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final currentUserId = SharedPreferencesService.getString(
                        PreferencesKeys.userId,
                      );

                      final relationships = relationshipState
                          .acceptedRelationships
                          .where((rel) => rel.caregiverId == currentUserId)
                          .toList();

                      if (relationships.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  PhosphorIcons.users(),
                                  size: 64,
                                  color: BaseColors.textSecondary,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum ada klien terhubung',
                                  style: FontTheme.textMedium.copyWith(
                                    color: BaseColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Hubungkan dengan klien untuk melihat aktivitas mereka',
                                  textAlign: TextAlign.center,
                                  style: FontTheme.textRegular.copyWith(
                                    color: BaseColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Client Selector
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Client Selector Dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      PhosphorIcons.users(),
                                      size: 18,
                                      color: BaseColors.info.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Pilih Klien',
                                      style: FontTheme.textSemiBold.copyWith(
                                        fontSize: 14,
                                        color: BaseColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: BaseColors.borderLight,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: selectedClientId,
                                  isExpanded: true,
                                  underline: const SizedBox.shrink(),
                                  icon: Icon(
                                    PhosphorIcons.caretDown(),
                                    color: BaseColors.info.shade600,
                                    size: 20,
                                  ),
                                  hint: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: BaseColors.neutral.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          PhosphorIcons.user(),
                                          color: BaseColors.textTertiary,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Pilih Klien',
                                        style: FontTheme.textRegular.copyWith(
                                          color: BaseColors.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: relationships.map((relationship) {
                                    final clientId = relationship.clientId;
                                    final clientName = clientNames[clientId] ??
                                        relationship.clientName ??
                                        'Client';
                                    return DropdownMenuItem<String>(
                                      value: clientId,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: BaseColors.info.shade50,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: BaseColors.info.shade200,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              PhosphorIcons.user(),
                                              color: BaseColors.info.shade600,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  clientName,
                                                  style: FontTheme.textSemiBold,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Klien',
                                                  style: FontTheme.textRegular
                                                      .copyWith(
                                                    color: BaseColors.textSecondary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _onClientSelected,
                                  style: FontTheme.textSemiBold,
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Mood Summary (for selected client)
                          if (selectedClientId != null) ...[
                            CaregiverMoodSummary(userId: selectedClientId!),
                            const SizedBox(height: 16),
                          ],
                          // Activity Filter Buttons
                          ActivityFilterButtons(
                            selectedFeature: selectedFeature,
                            onFeatureSelected: (feature) {
                              setState(() {
                                selectedFeature = feature;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          // Selected Client Activities
                          if (selectedClientId != null)
                            _buildClientActivities(selectedClientId!)
                          else
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Pilih klien untuk melihat aktivitas',
                                  style: FontTheme.textRegular.copyWith(
                                    color: BaseColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateListHeight(int itemCount) {
    const double itemHeight = 80.0;
    const double separatorHeight = 14.0;
    const int maxItems = 5;
    final int displayCount = itemCount > maxItems ? maxItems : itemCount;
    return (displayCount * itemHeight) +
        ((displayCount - 1) * separatorHeight);
  }

  Color _getIconBackgroundColor(String feature) {
    switch (feature) {
      case 'journal':
        return BaseColors.orange.shade50;
      case 'moodlog':
        return BaseColors.rose.shade50;
      case 'todo':
        return BaseColors.success.shade50;
      case 'counseling':
        return BaseColors.info.shade50;
      case 'relationship':
        return BaseColors.purple.shade50;
      case 'payment':
        return BaseColors.info.shade50;
      default:
        return BaseColors.neutral.shade50;
    }
  }

  Color _getIconColor(String feature) {
    switch (feature) {
      case 'journal':
        return BaseColors.orange.shade400;
      case 'moodlog':
        return BaseColors.rose.shade400;
      case 'todo':
        return BaseColors.success.shade400;
      case 'counseling':
        return BaseColors.info.shade400;
      case 'relationship':
        return BaseColors.purple.shade400;
      case 'payment':
        return BaseColors.info.shade400;
      default:
        return BaseColors.neutral.shade400;
    }
  }

  IconData _getIconData(String feature) {
    switch (feature) {
      case 'journal':
        return PhosphorIcons.notebook();
      case 'moodlog':
        return PhosphorIcons.smiley();
      case 'todo':
        return PhosphorIcons.checkSquare();
      case 'counseling':
        return PhosphorIcons.chatCenteredText();
      case 'relationship':
        return PhosphorIcons.users();
      case 'payment':
        return PhosphorIcons.creditCard();
      default:
        return PhosphorIcons.listBullets();
    }
  }

  Widget _buildClientActivities(String clientId) {
    final clientName = clientNames[clientId] ?? 'Client';
    final activities = clientActivities[clientId] ?? [];

    // Filter activities if needed
    final filteredActivities = selectedFeature == 'all'
        ? activities
        : activities
            .where((a) => a.feature == selectedFeature)
            .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (filteredActivities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                PhosphorIcons.listBullets(),
                size: 64,
                color: BaseColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak ada aktivitas',
                style: FontTheme.textMedium.copyWith(
                  color: BaseColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Klien $clientName belum memiliki aktivitas',
                textAlign: TextAlign.center,
                style: FontTheme.textRegular.copyWith(
                  color: BaseColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Client header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: BaseColors.info.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.user(),
                  color: BaseColors.info.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clientName,
                      style: FontTheme.bodyBold,
                    ),
                    Text(
                      '${filteredActivities.length} aktivitas',
                      style: FontTheme.textRegular.copyWith(
                        color: BaseColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: _calculateListHeight(filteredActivities.length),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredActivities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) => _ActivityHistoryItem(
                activity: filteredActivities[index],
                iconBackground:
                    _getIconBackgroundColor(filteredActivities[index].feature),
                iconColor: _getIconColor(filteredActivities[index].feature),
                iconData: _getIconData(filteredActivities[index].feature),
                timestampText:
                    _formatTimestamp(filteredActivities[index].timestamp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Baru saja';
        }
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _ActivityHistoryItem extends StatelessWidget {
  final Activity activity;
  final Color iconBackground;
  final Color iconColor;
  final IconData iconData;
  final String timestampText;

  const _ActivityHistoryItem({
    required this.activity,
    required this.iconBackground,
    required this.iconColor,
    required this.iconData,
    required this.timestampText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(iconData, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: FontTheme.textSemiBold,
              ),
              const SizedBox(height: 4),
              Text(
                activity.description,
                style: FontTheme.textRegular.copyWith(
                  color: BaseColors.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                timestampText,
                style: FontTheme.captionRegular.copyWith(
                  color: BaseColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

