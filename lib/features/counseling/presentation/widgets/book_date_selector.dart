import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class BookDateSelector extends StatelessWidget {
  final List<Map<String, dynamic>> dates;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const BookDateSelector({
    super.key,
    required this.dates,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pilih tanggal', style: FontTheme.textSemiBold),
          const SizedBox(height: 2),
          Text(
            'Pilih hari yang tersedia',
            style: FontTheme.textRegular.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onSelect(i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? Color(0xFFE0F2FE) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            selected
                                ? BaseColors.secondary.shade800
                                : Colors.grey.shade200,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dates[i]['label'],
                          style: FontTheme.textSemiBold.copyWith(
                            color:
                                selected
                                    ? BaseColors.secondary.shade600
                                    : Colors.black,
                          ),
                        ),
                        Text(
                          dates[i]['desc'],
                          style: FontTheme.textRegular.copyWith(
                            color:
                                selected
                                    ? BaseColors.secondary.shade600
                                    : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
