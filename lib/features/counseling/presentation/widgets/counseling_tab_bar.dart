import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class CounselingTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  CounselingTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final tabs = const ['Semua', 'Berjalan', 'Selesai', 'Dibatalkan'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final selected = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[index],
                  style: FontTheme.textMedium.copyWith(
                    color:
                        selected ? BaseColors.secondary.shade800 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  width: selected ? 32 : 0,
                  decoration: BoxDecoration(
                    color:
                        selected
                            ? BaseColors.secondary.shade800
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
