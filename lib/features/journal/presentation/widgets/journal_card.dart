import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/journal/domain/entities/journal.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  final VoidCallback? onTap;

  const JournalCard({super.key, required this.journal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(journal.title, style: FontTheme.textBold),
            const SizedBox(height: 4),
            Text(
              journal.shortContent,
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
                  journal.formattedDate,
                  style: FontTheme.captionRegular.copyWith(
                    color: const Color(0xFFB0B0B0),
                  ),
                ),
                const Spacer(),
                if (journal.isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: BaseColors.primary.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Hari ini',
                      style: FontTheme.captionSemiBold.copyWith(
                        color: BaseColors.primary.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
