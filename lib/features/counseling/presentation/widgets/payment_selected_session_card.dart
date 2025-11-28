import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';

class PaymentSelectedSessionCard extends StatelessWidget {
  final CounselingSchedule? schedule;

  const PaymentSelectedSessionCard({super.key, this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BaseColors.neutral.shade200, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: BaseColors.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tidak ada jadwal yang dipilih',
                style: FontTheme.bodyMedium.copyWith(
                  color: BaseColors.neutral.shade600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.primary.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: BaseColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: BaseColors.success,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Jadwal Terpilih',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.success.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/doctor.jpg',
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
                    Text(
                      schedule!.title,
                      style: FontTheme.bodySemiBold.copyWith(
                        color: BaseColors.neutral.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule!.counselorName,
                      style: FontTheme.bodyMedium.copyWith(
                        color: BaseColors.neutral.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: BaseColors.neutral.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${schedule!.formattedDate}, ${schedule!.formattedDateTime}',
                          style: FontTheme.captionMedium.copyWith(
                            color: BaseColors.neutral.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: BaseColors.neutral.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          schedule!.formattedTime,
                          style: FontTheme.captionMedium.copyWith(
                            color: BaseColors.neutral.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (schedule!.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BaseColors.neutral.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi Sesi:',
                    style: FontTheme.captionSemiBold.copyWith(
                      color: BaseColors.neutral.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    schedule!.description,
                    style: FontTheme.captionMedium.copyWith(
                      color: BaseColors.neutral.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
