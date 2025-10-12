import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_header.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_summary_chart.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_average_card.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_best_card.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_history_list.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final moodSummary = [1, 2, 3, 4, 5, 4, 3]; // 1-5 scale for each day
    final weekRange = '23 Juni - 29 Juni 2025';
    final averageMood = 4.0;
    final bestMood = {'day': 'Jumat, 27 Juni', 'mood': 'Sangat Baik'};
    final activityHistory = [
      {
        'icon': PhosphorIcons.heart(),
        'iconBg': BaseColors.rose.shade50,
        'iconColor': BaseColors.rose.shade400,
        'borderColor': BaseColors.rose.shade100,
        'title': 'Mengisi mood tracker',
        'subtitle': 'Mood: Sangat baik',
        'bold': true,
      },
      {
        'icon': PhosphorIcons.checkSquare(),
        'iconBg': BaseColors.success.shade50,
        'iconColor': BaseColors.success.shade400,
        'borderColor': BaseColors.success.shade100,
        'title': 'Tugas selesai',
        'subtitle': 'Mandi pagi',
        'bold': true,
      },
      {
        'icon': PhosphorIcons.note(),
        'iconBg': BaseColors.orange.shade50,
        'iconColor': BaseColors.orange.shade400,
        'borderColor': BaseColors.orange.shade100,
        'title': 'Menulis jurnal',
        'subtitle': 'Menulis tentang hari ini',
        'bold': true,
      },
      {
        'icon': PhosphorIcons.calendarCheck(),
        'iconBg': BaseColors.info.shade50,
        'iconColor': BaseColors.info.shade400,
        'borderColor': BaseColors.info.shade100,
        'title': 'Melakukan konseling',
        'subtitle': 'Dengan Daffa Zuhdii - 60 Menit',
        'bold': true,
      },
      {
        'icon': PhosphorIcons.heart(),
        'iconBg': BaseColors.rose.shade50,
        'iconColor': BaseColors.rose.shade400,
        'borderColor': BaseColors.rose.shade100,
        'title': 'Mengisi mood tracker',
        'subtitle': 'Mood: Buruk',
        'bold': true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ActivityHeader(),
              const SizedBox(height: 16),
              MoodSummaryChart(moodSummary: moodSummary, weekRange: weekRange),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              ActivityHistoryList(history: activityHistory),
            ],
          ),
        ),
      ),
    );
  }
}
