import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/activity/domain/entities/activity.dart';
import 'package:temanmu/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivityHistoryList extends StatelessWidget {
  final List<Activity> activities;
  final ActivityCubit cubit;

  const ActivityHistoryList({
    super.key,
    required this.activities,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Riwayat aktivitas', style: FontTheme.textSemiBold),
          const SizedBox(height: 2),
          Text('Yang sudah kamu lakukan', style: FontTheme.captionRegular),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      PhosphorIcons.clock(),
                      size: 48,
                      color: BaseColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada aktivitas',
                      style: FontTheme.textMedium.copyWith(
                        color: BaseColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mulai lakukan aktivitas untuk melihat riwayat di sini',
                      style: FontTheme.captionRegular.copyWith(
                        color: BaseColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...activities.map(
              (activity) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BaseColors.borderLight, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getIconBackgroundColor(activity.feature),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              _getIconData(activity.feature),
                              color: _getIconColor(activity.feature),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.title,
                                style: FontTheme.textMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (activity.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    activity.description,
                                    style: FontTheme.captionRegular.copyWith(
                                      color: BaseColors.textSecondary,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(activity.timestamp),
                                style: FontTheme.captionRegular.copyWith(
                                  color: BaseColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
        return PhosphorIcons.note();
      case 'moodlog':
        return PhosphorIcons.heart();
      case 'todo':
        return PhosphorIcons.checkSquare();
      case 'counseling':
        return PhosphorIcons.chatCircle();
      case 'relationship':
        return PhosphorIcons.users();
      case 'payment':
        return PhosphorIcons.creditCard();
      default:
        return PhosphorIcons.circle();
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}
