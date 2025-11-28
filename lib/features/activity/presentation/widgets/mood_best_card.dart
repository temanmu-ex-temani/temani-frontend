import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class MoodBestCard extends StatelessWidget {
  final String day;
  final String mood;
  const MoodBestCard({super.key, required this.day, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mood terbaik', style: FontTheme.textSemiBold),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.sentiment_very_satisfied,
                color: Color(0xFF8ECFFF),
                size: 28,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day, style: FontTheme.textMedium),
                    Text(mood, style: FontTheme.captionRegular),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
