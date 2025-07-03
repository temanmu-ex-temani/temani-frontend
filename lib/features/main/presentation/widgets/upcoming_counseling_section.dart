import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class UpcomingCounselingSection extends StatelessWidget {
  const UpcomingCounselingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sesi konseling mendatang', style: FontTheme.textMedium),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BaseColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/doctor.jpg',
                    width: 64,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chika',
                            style: FontTheme.textRegular.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: BaseColors.orange.shade100,
                              border: Border.all(
                                color: BaseColors.orange.shade200,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Berlangsung',
                              style: FontTheme.captionRegular.copyWith(
                                color: BaseColors.orange.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.calendarBlank(),
                            size: 16,
                            color: BaseColors.textSecondary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Rabu, 2 Juli 2025',
                            style: FontTheme.captionRegular.copyWith(
                              color: BaseColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.clock(),
                            size: 16,
                            color: BaseColors.textSecondary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '19:00 - 20:00',
                            style: FontTheme.captionRegular.copyWith(
                              color: BaseColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BaseColors.info.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                              ),
                              child: Text(
                                'Gabung',
                                style: FontTheme.textSemiBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BaseColors.info.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                elevation: 0,
                              ),
                              child: Text(
                                'Detail',
                                style: FontTheme.textSemiBold.copyWith(
                                  color: BaseColors.info.shade800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
