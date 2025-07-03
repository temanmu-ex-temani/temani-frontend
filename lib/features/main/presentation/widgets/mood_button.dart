import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({required this.scale, super.key});
  final int scale;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String text;

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
    return Container(
      padding: EdgeInsets.all(6),
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        border: Border.all(color: BaseColors.borderMedium),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Text(
            text,
            style: FontTheme.captionRegular,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
