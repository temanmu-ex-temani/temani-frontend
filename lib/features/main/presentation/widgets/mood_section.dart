import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/main/presentation/widgets/mood_button.dart';

class MoodSection extends StatelessWidget {
  const MoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bagaimana perasaanmu?', style: FontTheme.textMedium),
          Text(
            'Sini cerita!',
            style: FontTheme.textMedium.copyWith(
              color: BaseColors.textSecondary,
            ),
          ),
          SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                MoodButton(scale: 1),
                SizedBox(width: 4),
                MoodButton(scale: 2),
                SizedBox(width: 4),
                MoodButton(scale: 3),
                SizedBox(width: 4),
                MoodButton(scale: 4),
                SizedBox(width: 4),
                MoodButton(scale: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
