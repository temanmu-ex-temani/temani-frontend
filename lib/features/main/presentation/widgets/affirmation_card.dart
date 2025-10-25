import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/main/data/services/affirmation_service.dart';

class AffirmationCard extends StatelessWidget {
  const AffirmationCard({super.key});

  String get _randomAffirmation => AffirmationService.getRandomAffirmation();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF51A2FF), Color(0xFF00D3F3)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.sparkle(), color: BaseColors.white),
              SizedBox(width: 6),
              Text(
                'Afirmasi hari ini',
                style: FontTheme.textRegular.copyWith(color: BaseColors.white),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _randomAffirmation,
            style: FontTheme.bodyRegular.copyWith(color: BaseColors.white),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
