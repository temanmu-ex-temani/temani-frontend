import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class MoodButton extends StatelessWidget {
  final int scale;
  final bool selected;
  final bool dimmed;
  final VoidCallback? onTap;
  const MoodButton({
    required this.scale,
    this.selected = false,
    this.dimmed = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String text;
    Color borderColor;
    Color iconColor;
    Color textColor;
    Color bgColor;
    Color grey = BaseColors.neutral.shade300;

    switch (scale) {
      case 1:
        icon = PhosphorIcons.smileyAngry();
        color = BaseColors.rose.shade400;
        text = 'Sangat Buruk';
        break;
      case 2:
        icon = PhosphorIcons.smileySad();
        color = BaseColors.orange.shade300;
        text = 'Buruk';
        break;
      case 3:
        icon = PhosphorIcons.smileyMeh();
        color = BaseColors.yellow.shade300;
        text = 'Biasa Saja';
        break;
      case 4:
        icon = PhosphorIcons.smiley();
        color = BaseColors.green.shade300;
        text = 'Baik';
        break;
      case 5:
        icon = PhosphorIcons.smileySticker();
        color = BaseColors.primary.shade300;
        text = 'Sangat Baik';
        break;
      default:
        icon = PhosphorIcons.smileyAngry();
        color = BaseColors.rose.shade400;
        text = 'Sangat Buruk';
    }

    if (selected) {
      borderColor = color;
      iconColor = color;
      textColor = color;
      bgColor = color.withOpacity(0.12);
    } else if (dimmed) {
      borderColor = grey;
      iconColor = grey;
      textColor = grey;
      bgColor = Colors.transparent;
    } else {
      borderColor = color;
      iconColor = color;
      textColor = color;
      bgColor = Colors.transparent;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 76,
        height: 90,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(height: 4),
            Text(
              text,
              style: FontTheme.captionRegular.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
