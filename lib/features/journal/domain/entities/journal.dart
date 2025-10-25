class Journal {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Journal({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper methods for UI
  String get formattedDate {
    final now = DateTime.now();
    final journalDate = createdAt;

    if (journalDate.year == now.year &&
        journalDate.month == now.month &&
        journalDate.day == now.day) {
      return 'Hari ini';
    } else if (journalDate.year == now.year &&
        journalDate.month == now.month &&
        journalDate.day == now.day - 1) {
      return 'Kemarin';
    } else {
      final months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      final days = [
        'Senin',
        'Selasa',
        'Rabu',
        'Kamis',
        'Jumat',
        'Sabtu',
        'Minggu',
      ];
      return '${days[journalDate.weekday - 1]}, ${journalDate.day} ${months[journalDate.month - 1]} ${journalDate.year}';
    }
  }

  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDateTime {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day/$month/$year';
  }

  String get shortContent {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inDays <= 7;
  }
}
