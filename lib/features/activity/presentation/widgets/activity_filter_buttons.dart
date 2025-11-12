import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class ActivityFilterButtons extends StatelessWidget {
  final String selectedFeature;
  final Function(String) onFeatureSelected;

  const ActivityFilterButtons({
    super.key,
    required this.selectedFeature,
    required this.onFeatureSelected,
  });

  @override
  Widget build(BuildContext context) {
    final features = [
      {'value': 'all', 'label': 'Semua', 'icon': '📋'},
      {'value': 'journal', 'label': 'Journal', 'icon': '📝'},
      {'value': 'moodlog', 'label': 'Mood', 'icon': '😊'},
      {'value': 'todo', 'label': 'Todo', 'icon': '✅'},
      {'value': 'counseling', 'label': 'Konseling', 'icon': '💬'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: features.map((feature) {
            final isSelected = selectedFeature == feature['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onFeatureSelected(feature['value']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? BaseColors.info : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? BaseColors.info : BaseColors.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        feature['icon']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        feature['label']!,
                        style: FontTheme.captionMedium.copyWith(
                          color: isSelected ? Colors.white : BaseColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
