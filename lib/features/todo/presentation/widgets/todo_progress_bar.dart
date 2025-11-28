import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class TodoProgressBar extends StatelessWidget {
  const TodoProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final int completed = 2;
    final int total = 4;
    final double percent = completed / total;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progres hari ini',
                  style: FontTheme.captionSemiBold.copyWith(
                    color: const Color(0xFF4B9EFF),
                  ),
                ),
                Text(
                  '$completed dari $total tugas selesai',
                  style: FontTheme.captionRegular,
                ),
              ],
            ),
          ),
          Text('${(percent * 100).toInt()}%', style: FontTheme.captionSemiBold),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: const Color(0xFFD6E6F7),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4B9EFF),
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
