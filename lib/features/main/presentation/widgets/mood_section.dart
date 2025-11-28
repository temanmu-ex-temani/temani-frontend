import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'mood_button.dart';

class MoodSection extends StatefulWidget {
  const MoodSection({super.key});

  @override
  State<MoodSection> createState() => _MoodSectionState();
}

class _MoodSectionState extends State<MoodSection> {
  int? selectedMood; // null = initial state

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bagaimana perasaanmu?', style: FontTheme.textMedium),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(5, (index) {
              final moodScale = index + 1;
              final isSelected = selectedMood == index;
              final isDimmed = selectedMood != null && !isSelected;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MoodButton(
                  scale: moodScale,
                  selected: isSelected,
                  dimmed: isDimmed,
                  onTap: () {
                    setState(() {
                      selectedMood = index;
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
