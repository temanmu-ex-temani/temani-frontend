import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/themes/_themes.dart';

class MoodSummaryChart extends StatelessWidget {
  final List<int> moodSummary; // 1-5 scale for each day
  final String weekRange;
  final VoidCallback? onPreviousWeek;
  final VoidCallback? onNextWeek;
  final VoidCallback? onWeekTap;
  final bool canGoNext;

  const MoodSummaryChart({
    super.key,
    required this.moodSummary,
    required this.weekRange,
    this.onPreviousWeek,
    this.onNextWeek,
    this.onWeekTap,
    this.canGoNext = false,
  });

  static const List<String> days = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];
  static const List<Color> moodColors = [
    Color(0xFFE5E7EB), // 1 - Sangat Buruk (grey)
    Color(0xFFFFC48A), // 2 - Buruk (orange)
    Color(0xFFFFE066), // 3 - Biasa Saja (yellow)
    Color(0xFF8ECFFF), // 4 - Baik (blue)
    Color(0xFF7EE787), // 5 - Sangat Baik (green)
  ];

  // For smiley faces
  static final List<IconData> moodIcons = [
    PhosphorIcons.smileyAngry(),
    PhosphorIcons.smileySad(),
    PhosphorIcons.smileyMeh(),
    PhosphorIcons.smiley(),
    PhosphorIcons.smileySticker(),
  ];
  static final List<Color> moodIconColors = [
    BaseColors.rose.shade400,
    BaseColors.orange.shade300,
    BaseColors.yellow.shade300,
    BaseColors.green.shade300,
    BaseColors.primary.shade300,
  ];

  Color getMoodColor(int mood) {
    if (mood < 1 || mood > 5) return moodColors[0];
    return moodColors[mood - 1];
  }

  double getBarHeight(int mood) {
    // Gradually increasing heights for each scale (1-5)
    // e.g. 1: 28, 2: 46, 3: 64, 4: 82, 5: 100
    switch (mood) {
      case 1:
        return 28;
      case 2:
        return 46;
      case 3:
        return 64;
      case 4:
        return 82;
      case 5:
        return 100;
      default:
        return 28;
    }
  }

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
          Text('Ringkasan mood kamu', style: FontTheme.textSemiBold),
          const SizedBox(height: 2),
          Text('Dalam seminggu', style: FontTheme.captionRegular),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (i) {
                final mood = moodSummary.length > i ? moodSummary[i] : 1;
                final barHeight = getBarHeight(mood);
                final icon = moodIcons[(mood - 1).clamp(0, 4)];
                final iconColor = moodIconColors[(mood - 1).clamp(0, 4)];
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Smiley icon above the bar
                      Icon(icon, color: iconColor, size: 22),
                      const SizedBox(height: 4),
                      // Bar
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400),
                        height: barHeight,
                        width: 18,
                        decoration: BoxDecoration(
                          color: getMoodColor(mood),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child:
                              mood == 1
                                  ? Icon(
                                    Icons.circle,
                                    color: Color(0xFFFF6B6B),
                                    size: 12,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 16,
                        child: Text(days[i], style: FontTheme.captionRegular),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: BaseColors.info.shade600),
                onPressed: onPreviousWeek,
                splashRadius: 20,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onWeekTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: BaseColors.info.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: BaseColors.info.shade100),
                    ),
                    child: Text(
                      weekRange,
                      textAlign: TextAlign.center,
                      style: FontTheme.textMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BaseColors.info.shade700,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color:
                      canGoNext
                          ? BaseColors.info.shade600
                          : const Color(0xFF9CA3AF),
                ),
                onPressed: canGoNext ? onNextWeek : null,
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
