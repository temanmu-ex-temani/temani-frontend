import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class BookCounselorList extends StatelessWidget {
  final List<Map<String, dynamic>> counselors;
  final int? selectedCounselorIndex;
  final int? selectedTimeIndex;
  final ValueChanged<int> onSelectCounselor;
  final void Function(int counselorIdx, int timeIdx) onSelectTime;
  const BookCounselorList({
    super.key,
    required this.counselors,
    required this.selectedCounselorIndex,
    required this.selectedTimeIndex,
    required this.onSelectCounselor,
    required this.onSelectTime,
  });

  Widget buildRatingBar(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i < fullStars
                ? Icons.star
                : (i == fullStars && halfStar)
                ? Icons.star_half
                : Icons.star_border,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pilih konselor sebaya', style: FontTheme.textBold),
          const SizedBox(height: 2),
          Text(
            'Mereka siap mendengarkanmu',
            style: FontTheme.captionRegular.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          ...List.generate(counselors.length, (i) {
            final c = counselors[i];
            final isSelected = selectedCounselorIndex == i;
            return GestureDetector(
              onTap: () => onSelectCounselor(i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isSelected
                            ? BaseColors.secondary.shade600
                            : BaseColors.borderLight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        c['image'],
                        width: 64,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name'], style: FontTheme.textBold),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              buildRatingBar(c['rating']),
                              const SizedBox(width: 6),
                              Text(
                                '${c['rating']}',
                                style: FontTheme.captionRegular.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '(${c['reviews']}+)',
                                style: FontTheme.captionRegular.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(c['slots'].length, (j) {
                              final slot = c['slots'][j];
                              final slotSelected =
                                  isSelected && selectedTimeIndex == j;
                              return GestureDetector(
                                onTap:
                                    slot['enabled']
                                        ? () => onSelectTime(i, j)
                                        : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        slotSelected
                                            ? Color(0xFFE0F2FE)
                                            : slot['enabled']
                                            ? Colors.white
                                            : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          slotSelected
                                              ? BaseColors.secondary.shade500
                                              : slot['enabled']
                                              ? Colors.grey.shade300
                                              : Colors.grey.shade200,
                                      width: slotSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    slot['time'],
                                    style: FontTheme.captionRegular.copyWith(
                                      color:
                                          slotSelected
                                              ? BaseColors.secondary.shade800
                                              : slot['enabled']
                                              ? Colors.black
                                              : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
