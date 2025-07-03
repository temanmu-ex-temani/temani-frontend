
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF51A2FF), Color(0xFF00D3F3)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(PhosphorIcons.sparkle(), color: BaseColors.white),
                  SizedBox(width: 6),
                  Text(
                    'Afirmasi hari ini',
                    style: FontTheme.textRegular.copyWith(
                      color: BaseColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                text,
                style: FontTheme.bodyRegular.copyWith(color: BaseColors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
