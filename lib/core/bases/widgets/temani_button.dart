import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class TemaniButton extends StatelessWidget {
  const TemaniButton({required this.type, super.key});
  final int type;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor;
    bool borderOn = false;
    Color? borderColor;
    double? borderWidth;
    switch (type) {
      case 0:
        bgColor = BaseColors.secondary.shade400;
        textColor = BaseColors.white;
        break;
      case 1:
        bgColor = BaseColors.secondary.shade100;
        textColor = BaseColors.secondary.shade900;
        break;
      case 2:
        bgColor = BaseColors.scaffoldBackground;
        textColor = BaseColors.rose.shade400;
        borderOn = true;
        borderColor = BaseColors.rose.shade200;
        borderWidth = 2;
        break;
      case 3:
        bgColor = null;
        textColor = BaseColors.white;
        break;
      default:
        bgColor = BaseColors.secondary;
        textColor = BaseColors.white;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border:
            borderOn
                ? Border.all(
                  color: borderColor ?? BaseColors.borderMedium,
                  width: borderWidth ?? 1.0,
                )
                : null,

        gradient:
            type == 3
                ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF51A2FF), Color(0xFF00D3F3)],
                )
                : null,
      ),
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIcons.caretLeft(), color: textColor),
            SizedBox(width: 8),
            Text(
              "Button",
              style: FontTheme.textRegular.copyWith(color: textColor),
            ),
            SizedBox(width: 8),
            Icon(PhosphorIcons.caretRight(), color: textColor),
          ],
        ),
      ),
    );
  }
}
