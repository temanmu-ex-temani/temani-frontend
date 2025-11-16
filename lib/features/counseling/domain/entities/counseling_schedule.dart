class CounselingSchedule {
  final String id;
  final String? clientId;
  final String? clientName;
  final String counselorId;
  final String counselorName;
  final String counselorUsername;
  final DateTime scheduledAt;
  final String title;
  final String description;
  final String meetingLink;
  final String notes;
  final String status;

  CounselingSchedule({
    required this.id,
    this.clientId,
    this.clientName,
    required this.counselorId,
    required this.counselorName,
    required this.counselorUsername,
    required this.scheduledAt,
    required this.title,
    required this.description,
    required this.meetingLink,
    required this.notes,
    required this.status,
  });

  // Helper methods for UI
  String get formattedDate {
    final now = DateTime.now();
    final scheduleDate = scheduledAt;

    if (scheduleDate.year == now.year &&
        scheduleDate.month == now.month &&
        scheduleDate.day == now.day) {
      return 'Hari ini';
    } else if (scheduleDate.year == now.year &&
        scheduleDate.month == now.month &&
        scheduleDate.day == now.day + 1) {
      return 'Besok';
    } else {
      final days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      return days[scheduleDate.weekday - 1];
    }
  }

  String get formattedTime {
    final hour = scheduledAt.hour.toString().padLeft(2, '0');
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDateTime {
    final day = scheduledAt.day.toString().padLeft(2, '0');
    final month = scheduledAt.month.toString().padLeft(2, '0');
    final year = scheduledAt.year;
    return '$day/$month/$year';
  }

  bool get isAvailable => status == 'AVAILABLE';
}
