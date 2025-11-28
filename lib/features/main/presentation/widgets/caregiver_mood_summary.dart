import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temanmu/features/activity/presentation/widgets/mood_summary_chart.dart';
import 'package:temanmu/features/activity/presentation/widgets/mood_average_card.dart';
import 'package:temanmu/features/activity/presentation/widgets/mood_best_card.dart';

class CaregiverMoodSummary extends StatelessWidget {
  final String userId;
  
  const CaregiverMoodSummary({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        if (state.status == MoodStatus.loading && state.moodSummary == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MoodStatus.error) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: Center(
              child: Text(
                'Error loading mood summary',
                style: FontTheme.textMedium.copyWith(
                  color: BaseColors.textSecondary,
                ),
              ),
            ),
          );
        }

        if (state.moodSummary == null) {
          return const SizedBox.shrink();
        }

        final summary = state.moodSummary!;
        final moodCubit = context.read<MoodCubit>();
        final selectedWeekStart =
            state.selectedWeekStart ?? moodCubit.currentWeekStart;

        // Convert API data to chart format
        final moodSummary = _convertToChartData(summary.weeklyMood);
        final weekStartDate =
            _parseDate(summary.weekStart) ?? selectedWeekStart;
        final weekEndDate =
            _parseDate(summary.weekEnd) ?? weekStartDate.add(const Duration(days: 6));
        final weekRange =
            '${_formatDate(weekStartDate)} - ${_formatDate(weekEndDate)}';
        final canGoNext = selectedWeekStart.isBefore(moodCubit.currentWeekStart);
        final averageMood = summary.averageScore;
        final bestMood = {
          'day': summary.bestMood.dayOfWeek,
          'mood': summary.bestMood.moodVisual,
        };

        return Column(
          children: [
            // Mood Summary Chart
            MoodSummaryChart(
              moodSummary: moodSummary,
              weekRange: weekRange,
              onPreviousWeek: () => _loadPreviousWeek(context, moodCubit),
              onNextWeek: canGoNext ? () => _loadNextWeek(context, moodCubit) : null,
              onWeekTap: () => _showWeekPicker(
                context,
                moodCubit,
                selectedWeekStart,
              ),
              canGoNext: canGoNext,
            ),
            const SizedBox(height: 16),

            // Average and Best Mood Cards
            Row(
              children: [
                Expanded(child: MoodAverageCard(average: averageMood)),
                const SizedBox(width: 12),
                Expanded(
                  child: MoodBestCard(
                    day: bestMood['day']!,
                    mood: bestMood['mood']!,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _loadPreviousWeek(BuildContext context, MoodCubit cubit) {
    final base = cubit.state.selectedWeekStart ?? cubit.currentWeekStart;
    final previousWeek = base.subtract(const Duration(days: 7));
    cubit.loadMoodSummaryByUserId(userId, weekStart: previousWeek);
  }

  void _loadNextWeek(BuildContext context, MoodCubit cubit) {
    final base = cubit.state.selectedWeekStart ?? cubit.currentWeekStart;
    if (!base.isBefore(cubit.currentWeekStart)) return;
    final nextWeek = base.add(const Duration(days: 7));
    if (nextWeek.isAfter(cubit.currentWeekStart)) {
      cubit.loadMoodSummaryByUserId(userId, weekStart: cubit.currentWeekStart);
    } else {
      cubit.loadMoodSummaryByUserId(userId, weekStart: nextWeek);
    }
  }

  Future<void> _showWeekPicker(
    BuildContext context,
    MoodCubit cubit,
    DateTime initialWeekStart,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialWeekStart,
      firstDate: DateTime(2020, 1, 1),
      lastDate: cubit.currentWeekStart,
      helpText: 'Pilih tanggal mulai minggu',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
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
        );
      },
    );

    if (picked != null) {
      cubit.loadMoodSummaryByUserId(userId, weekStart: picked);
    }
  }

  // Convert API weekly mood data to chart format (1-5 scale)
  List<int> _convertToChartData(dynamic weeklyMood) {
    final days = [
      weeklyMood.monday,
      weeklyMood.tuesday,
      weeklyMood.wednesday,
      weeklyMood.thursday,
      weeklyMood.friday,
      weeklyMood.saturday,
      weeklyMood.sunday,
    ];

    return days.map((mood) {
      if (mood == 'No mood logged' || mood.isEmpty) {
        return 0; // No data
      }

      // Convert mood text to scale (1-5)
      switch (mood.toLowerCase()) {
        case 'sangat buruk':
          return 1;
        case 'buruk':
          return 2;
        case 'biasa saja':
          return 3;
        case 'baik':
          return 4;
        case 'sangat baik':
          return 5;
        default:
          return 0; // Unknown mood
      }
    }).toList();
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}

