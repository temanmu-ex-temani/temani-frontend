import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class MoodButtonReal extends StatelessWidget {
  final int scale;
  final bool selected;
  final VoidCallback? onTap;

  const MoodButtonReal({
    required this.scale,
    this.selected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final moodData = _getMoodData(scale);
    final isSelected = selected;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        width: 95,
        height: 110,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? moodData.color.withOpacity(0.15)
                  : Colors.transparent,
          border: Border.all(
            color:
                isSelected ? moodData.color : moodData.color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: moodData.color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? moodData.color.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                moodData.icon,
                color:
                    isSelected
                        ? moodData.color
                        : moodData.color.withOpacity(0.7),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              moodData.text,
              style: FontTheme.captionRegular.copyWith(
                color:
                    isSelected
                        ? moodData.color
                        : moodData.color.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  MoodData _getMoodData(int scale) {
    switch (scale) {
      case 1:
        return MoodData(
          icon: PhosphorIcons.smileyAngry(),
          color: BaseColors.rose.shade500,
          text: 'Sangat\nBuruk',
        );
      case 2:
        return MoodData(
          icon: PhosphorIcons.smileySad(),
          color: BaseColors.orange.shade500,
          text: 'Buruk',
        );
      case 3:
        return MoodData(
          icon: PhosphorIcons.smileyMeh(),
          color: BaseColors.yellow.shade500,
          text: 'Biasa\nSaja',
        );
      case 4:
        return MoodData(
          icon: PhosphorIcons.smiley(),
          color: BaseColors.green.shade500,
          text: 'Baik',
        );
      case 5:
        return MoodData(
          icon: PhosphorIcons.smileySticker(),
          color: BaseColors.primary.shade500,
          text: 'Sangat\nBaik',
        );
      default:
        return MoodData(
          icon: PhosphorIcons.smileyMeh(),
          color: BaseColors.neutral.shade500,
          text: 'Biasa\nSaja',
        );
    }
  }
}

class MoodData {
  final IconData icon;
  final Color color;
  final String text;

  MoodData({required this.icon, required this.color, required this.text});
}
