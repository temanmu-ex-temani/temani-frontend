import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final CounselingSchedule schedule;
  final bool isSelected;
  final VoidCallback onTap;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.isSelected,
    required this.onTap,
  });

  Color getStatusBgColor() {
    return Color(0xFFEFF6FF); // info.shade100
  }

  Color getStatusBorderColor() {
    return Color(0xFFBFDBFE); // info.shade200
  }

  Color getStatusTextColor() {
    return Color(0xFF38BDF8); // info.shade400
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? BaseColors.info.shade400 : BaseColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          schedule.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusBgColor(),
                          border: Border.all(color: getStatusBorderColor()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          schedule.status,
                          style: TextStyle(
                            color: getStatusTextColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.user(),
                        size: 16,
                        color: Color(0xFF64748B), // textSecondary
                      ),
                      const SizedBox(width: 6),
                      Text(
                        schedule.counselorName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.calendarBlank(),
                        size: 16,
                        color: Color(0xFF64748B), // textSecondary
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${schedule.formattedDate}, ${schedule.formattedDateTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.clock(),
                        size: 16,
                        color: Color(0xFF64748B), // textSecondary
                      ),
                      const SizedBox(width: 6),
                      Text(
                        schedule.formattedTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: BaseColors.info.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: BaseColors.info.shade400,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Jadwal Dipilih',
                            style: FontTheme.bodyMedium.copyWith(
                              color: BaseColors.info.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
