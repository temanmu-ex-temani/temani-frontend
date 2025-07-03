import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.username, super.key});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo,', style: FontTheme.textRegular),
            Text(username, style: FontTheme.textBold),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: BaseColors.white,
          ),
          child: Icon(PhosphorIcons.bellSimple()),
        ),
      ],
    );
  }
}
