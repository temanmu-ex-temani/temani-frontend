import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/schedule_card.dart';

class ScheduleList extends StatelessWidget {
  final List<CounselingSchedule> schedules;
  final CounselingSchedule? selectedSchedule;
  final Function(CounselingSchedule) onScheduleSelected;
  final bool isLoading;
  final String? errorMessage;

  const ScheduleList({
    super.key,
    required this.schedules,
    this.selectedSchedule,
    required this.onScheduleSelected,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: BaseColors.error.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.neutral.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: FontTheme.bodyMedium.copyWith(
                  color: BaseColors.neutral.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (schedules.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 64,
                color: BaseColors.neutral.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Tidak Ada Jadwal Tersedia',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.neutral.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tidak ada jadwal konseling yang tersedia\npada periode yang dipilih',
                style: FontTheme.bodyMedium.copyWith(
                  color: BaseColors.neutral.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Schedule count header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${schedules.length} jadwal tersedia',
            style: FontTheme.bodyMedium.copyWith(
              color: BaseColors.neutral.shade600,
            ),
          ),
        ),
        // Schedule list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final isSelected = selectedSchedule?.id == schedule.id;

              return ScheduleCard(
                schedule: schedule,
                isSelected: isSelected,
                onTap: () => onScheduleSelected(schedule),
              );
            },
          ),
        ),
      ],
    );
  }
}
