import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class JournalCard extends StatelessWidget {
  final String title;
  final String content;
  final String date;

  const JournalCard({
    super.key,
    required this.title,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EAF2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FontTheme.textBold),
          const SizedBox(height: 4),
          Text(
            content,
            style: FontTheme.textRegular.copyWith(
              color: const Color(0xFF7A7A7A),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: BaseColors.secondary.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Color(0xFFB0B0B0),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: FontTheme.captionRegular.copyWith(
                  color: const Color(0xFFB0B0B0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
