import 'package:flutter/material.dart';
import 'package:temanmu/core/bases/widgets/temani_button.dart';
import 'package:temanmu/core/themes/_themes.dart';

class JournalHeader extends StatelessWidget {
  final VoidCallback? onCreateJournal;

  const JournalHeader({super.key, this.onCreateJournal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ekspresikan perasaanmu', style: FontTheme.textSemiBold),
          const SizedBox(height: 4),
          Text(
            'Tuangkan dalam jurnal harian',
            style: FontTheme.captionRegular.copyWith(
              color: const Color(0xFF7A7A7A),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B9EFF), Color(0xFF4BE7F2)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TemaniButton(
                type: 3,
                text: 'Tulis jurnal',
                onPressed: onCreateJournal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
