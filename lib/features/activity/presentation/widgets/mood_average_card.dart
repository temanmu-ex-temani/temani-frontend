import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class MoodAverageCard extends StatelessWidget {
  final double average;
  const MoodAverageCard({super.key, required this.average});

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
          Text('Rata-rata mood', style: FontTheme.textSemiBold),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.sentiment_satisfied_alt,
                color: Color(0xFF7EE787),
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                average >= 4
                    ? 'Baik'
                    : average >= 3
                    ? 'Biasa'
                    : 'Buruk',
                style: FontTheme.textMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
