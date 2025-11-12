import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temani_frontend/features/mood/presentation/widgets/mood_button_real.dart';
import 'package:temani_frontend/features/mood/presentation/widgets/mood_update_dialog.dart';
import 'package:temani_frontend/services/toast_service.dart';

class MoodSectionReal extends StatefulWidget {
  const MoodSectionReal({super.key});

  @override
  State<MoodSectionReal> createState() => _MoodSectionRealState();
}

class _MoodSectionRealState extends State<MoodSectionReal> {
  int? selectedMood;
  late final MoodCubit _moodCubit;

  @override
  void initState() {
    super.initState();
    _moodCubit = context.read<MoodCubit>();
    _moodCubit.loadMoodLogs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoodCubit, MoodState>(
      listener: (context, state) {
        if (state.status == MoodStatus.error) {
          ToastService.show(context, state.errorMessage);
        } else if (state.status == MoodStatus.success && selectedMood != null) {
          ToastService.show(context, 'Mood berhasil dicatat!');
          setState(() {
            selectedMood = null;
          });
        }
      },
      builder: (context, state) {
        final todayMood = _moodCubit.getTodayMoodLog();
        final hasLoggedToday = todayMood != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bagaimana perasaanmu?', style: FontTheme.textMedium),
                if (hasLoggedToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: BaseColors.success.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: BaseColors.success.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sudah dicatat',
                          style: FontTheme.captionMedium.copyWith(
                            color: BaseColors.success.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasLoggedToday)
              _buildTodayMoodDisplay(todayMood)
            else
              _buildMoodSelection(),
            if (state.status == MoodStatus.loading)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTodayMoodDisplay(dynamic todayMood) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getMoodColor(todayMood.emotionScale).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getMoodIcon(todayMood.emotionScale),
              color: _getMoodColor(todayMood.emotionScale),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mood hari ini: ${_getMoodText(todayMood.emotionScale)}',
                  style: FontTheme.textMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Dicatat pada ${_formatTime(todayMood.timestamp)}',
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showUpdateDialog(todayMood);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: BaseColors.primary.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: BaseColors.primary.shade200),
              ),
              child: Text(
                'Ubah',
                style: FontTheme.captionMedium.copyWith(
                  color: BaseColors.primary.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          final moodScale = index + 1;
          final isSelected = selectedMood == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: MoodButtonReal(
              scale: moodScale,
              selected: isSelected,
              onTap: () {
                setState(() {
                  selectedMood = index;
                });
                _logMood(moodScale);
              },
            ),
          );
        }),
      ),
    );
  }

  void _logMood(int moodScale) {
    final moodVisual = _moodCubit.getMoodVisualFromScale(moodScale);
    _moodCubit.createMoodLog(moodVisual: moodVisual, emotionScale: moodScale);
  }

  void _showUpdateDialog(dynamic todayMood) {
    showDialog(
      context: context,
      builder:
          (context) =>
              MoodUpdateDialog(currentMood: todayMood, moodCubit: _moodCubit),
    );
  }

  Color _getMoodColor(int scale) {
    switch (scale) {
      case 1:
        return BaseColors.rose.shade400;
      case 2:
        return BaseColors.orange.shade400;
      case 3:
        return BaseColors.yellow.shade400;
      case 4:
        return BaseColors.green.shade400;
      case 5:
        return BaseColors.primary.shade400;
      default:
        return BaseColors.neutral.shade400;
    }
  }

  IconData _getMoodIcon(int scale) {
    switch (scale) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _getMoodText(int scale) {
    switch (scale) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Biasa Saja';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return 'Biasa Saja';
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else {
      return '${difference.inDays} hari yang lalu';
    }
  }
}
