import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_summary_chart.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_average_card.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_best_card.dart';

class MoodSummaryReal extends StatelessWidget {
  const MoodSummaryReal({super.key});

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

        // Convert API data to chart format
        final moodSummary = _convertToChartData(summary.weeklyMood);
        final weekRange = '${summary.weekStart} - ${summary.weekEnd}';
        final averageMood = summary.averageScore;
        final bestMood = {
          'day': summary.bestMood.dayOfWeek,
          'mood': summary.bestMood.moodVisual,
        };

        return Column(
          children: [
            // Mood Summary Chart (original design)
            MoodSummaryChart(moodSummary: moodSummary, weekRange: weekRange),
            const SizedBox(height: 16),

            // Average and Best Mood Cards (original design)
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
}
