import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/mood/presentation/cubit/mood_cubit.dart';

class MoodHistoryCard extends StatelessWidget {
  const MoodHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoodCubit, MoodState>(
      builder: (context, state) {
        final cubit = context.read<MoodCubit>();
        final recentMoods = cubit.getLastWeekMoodLogs();
        final averageMood = cubit.getAverageMood();

        if (recentMoods.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BaseColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mood Terbaru',
                    style: FontTheme.textMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (averageMood > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getAverageMoodColor(
                          averageMood,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Rata-rata: ${averageMood.toStringAsFixed(1)}',
                        style: FontTheme.captionMedium.copyWith(
                          color: _getAverageMoodColor(averageMood),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentMoods.take(7).length,
                  itemBuilder: (context, index) {
                    final mood = recentMoods[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildMoodItem(mood),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoodItem(dynamic mood) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: _getMoodColor(mood.emotionScale).withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: _getMoodColor(mood.emotionScale).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getMoodIcon(mood.emotionScale),
            color: _getMoodColor(mood.emotionScale),
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            _formatDate(mood.timestamp),
            style: FontTheme.captionRegular.copyWith(
              fontSize: 8,
              color: BaseColors.textSecondary,
            ),
          ),
        ],
      ),
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

  Color _getAverageMoodColor(double average) {
    if (average >= 4.5) return BaseColors.primary.shade400;
    if (average >= 3.5) return BaseColors.green.shade400;
    if (average >= 2.5) return BaseColors.yellow.shade400;
    if (average >= 1.5) return BaseColors.orange.shade400;
    return BaseColors.rose.shade400;
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      return '${difference.inDays}d';
    }
  }
}
