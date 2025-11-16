import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_session_card.dart';

class CounselingSessionList extends StatelessWidget {
  final List<CounselingSchedule> sessions;
  final bool showClientName;
  const CounselingSessionList({
    super.key,
    required this.sessions,
    this.showClientName = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final session in sessions)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CounselingSessionCard(
              id: session.id,
              name: showClientName
                  ? (session.status == 'AVAILABLE' 
                      ? '-' 
                      : (session.clientName ?? session.counselorName))
                  : session.counselorName,
              title: session.title,
              counselorId: session.counselorId,
              counselorName: session.counselorName,
              counselorUsername: session.counselorUsername,
              clientId: session.clientId,
              clientName: session.status == 'AVAILABLE' 
                  ? '-' 
                  : session.clientName,
              date: _formatDate(session.scheduledAt),
              time: _formatTime(session.scheduledAt),
              status: _getLocalizedStatus(session.status),
              rawStatus: session.status,
              image: 'assets/doctor.jpg', // Default image
              canJoin: _canJoinSession(session.status),
              showClientName: showClientName,
              description: session.description,
              meetingLink: session.meetingLink,
              notes: session.notes,
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    final indonesianMonths = [
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

    final indonesianDays = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];

    final dayName = indonesianDays[dateTime.weekday % 7];
    final day = dateTime.day;
    final month = indonesianMonths[dateTime.month - 1];
    final year = dateTime.year;

    return '$dayName, $day $month $year';
  }

  String _formatTime(DateTime dateTime) {
    final startTime = DateFormat('HH:mm').format(dateTime);
    final endTime = DateFormat(
      'HH:mm',
    ).format(dateTime.add(const Duration(hours: 1)));
    return '$startTime - $endTime';
  }

  String _getLocalizedStatus(String status) {
    switch (status) {
      case 'PENDING':
        return 'Terjadwal';
      case 'SCHEDULED':
        return 'Terjadwal';
      case 'ONGOING':
        return 'Berlangsung';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  bool _canJoinSession(String status) {
    return status == 'ONGOING';
  }
}
