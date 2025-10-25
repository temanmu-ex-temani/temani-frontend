import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/constants/_constants.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_details_bottom_sheet.dart';
import 'package:temani_frontend/services/router_service.dart';
import 'package:temani_frontend/services/shared_preference_service.dart';

class CounselingSessionCard extends StatelessWidget {
  final String id;
  final String name;
  final String title;
  final String counselorId;
  final String counselorUsername;
  final String? clientId;
  final String date;
  final String time;
  final String status;
  final String image;
  final bool canJoin;

  const CounselingSessionCard({
    super.key,
    required this.id,
    required this.name,
    required this.title,
    required this.counselorId,
    required this.counselorUsername,
    this.clientId,
    required this.date,
    required this.time,
    required this.status,
    required this.image,
    required this.canJoin,
  });

  Color getStatusBgColor() {
    switch (status) {
      case 'Terjadwal':
        return Color(0xFFEFF6FF); // info.shade100
      case 'Berlangsung':
        return Color(0xFFFFF3C7); // orange.shade100
      case 'Selesai':
        return Color(0xFFD1FAE5); // success.shade100
      case 'Dibatalkan':
        return Color(0xFFFEE2E2); // error.shade100
      default:
        return Color(0xFFF3F4F6); // neutral.shade100
    }
  }

  Color getStatusBorderColor() {
    switch (status) {
      case 'Terjadwal':
        return Color(0xFFBFDBFE); // info.shade200
      case 'Berlangsung':
        return Color(0xFFFDE68A); // orange.shade200
      case 'Selesai':
        return Color(0xFFA7F3D0); // success.shade200
      case 'Dibatalkan':
        return Color(0xFFFECACA); // error.shade200
      default:
        return Color(0xFFE5E7EB); // neutral.shade200
    }
  }

  Color getStatusTextColor() {
    switch (status) {
      case 'Terjadwal':
        return Color(0xFF38BDF8); // info.shade400
      case 'Berlangsung':
        return Color(0xFFF59E0B); // orange.shade400
      case 'Selesai':
        return Color(0xFF34D399); // success.shade400
      case 'Dibatalkan':
        return Color(0xFFF87171); // error.shade400
      default:
        return Color(0xFF9CA3AF); // neutral.shade400
    }
  }

  Color getJoinButtonColor() {
    return Color(0xFF38BDF8); // info.shade400
  }

  Color getJoinTextColor() {
    return Colors.white;
  }

  Color getDetailButtonColor() {
    return Color(0xFFEFF6FF); // info.shade100
  }

  Color getDetailTextColor() {
    return Color(0xFF1E40AF); // info.shade800
  }

  void _navigateToChatRoom() {
    // Use the schedule ID as session ID and counselor info
    final sessionId = id; // This is the schedule ID
    final counselorName = name; // This is the counselor display name

    // Get current user's ID
    final currentUserId = SharedPreferencesService.getString(
      PreferencesKeys.userId,
    );

    // Determine receiver ID based on user role
    String receiverId;
    if (currentUserId == counselorId) {
      // Current user is counselor -> receiver is client
      receiverId = clientId ?? '';
    } else {
      // Current user is client -> receiver is counselor
      receiverId = counselorId;
    }

    router.push(
      '/chat?sessionId=$sessionId&receiverId=$receiverId&counselorName=$counselorName',
    );
  }

  void _navigateToChatHistory() {
    // Use the schedule ID as session ID and counselor info
    final sessionId = id; // This is the schedule ID
    final counselorName = name; // This is the counselor display name

    // Get current user's ID
    final currentUserId = SharedPreferencesService.getString(
      PreferencesKeys.userId,
    );

    // Determine receiver ID based on user role
    String receiverId;
    if (currentUserId == counselorId) {
      // Current user is counselor -> receiver is client
      receiverId = clientId ?? '';
    } else {
      // Current user is client -> receiver is counselor
      receiverId = counselorId;
    }

    router.push(
      '/chat-history?sessionId=$sessionId&receiverId=$receiverId&counselorName=$counselorName',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BaseColors.borderLight,
          width: 2,
        ), // borderLight
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(image, width: 64, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
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
                        status,
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
                // Counselor name with icon
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.user(),
                      size: 16,
                      color: Color(0xFF64748B), // textSecondary
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.calendarBlank(),
                      size: 16,
                      color: Color(0xFF64748B), // textSecondary
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
                      time,
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    // Show "Gabung" button for active sessions
                    if (canJoin)
                      SizedBox(
                        width: double.infinity,
                        child: TemaniButton(
                          type: 3,
                          text: 'Gabung',
                          onPressed: () => _navigateToChatRoom(),
                        ),
                      ),

                    // Show "Konsultasi Saya" button for completed sessions
                    if (status == 'Selesai')
                      SizedBox(
                        width: double.infinity,
                        child: TemaniButton(
                          type: 3,
                          text: 'Konsultasi Saya',
                          onPressed: () => _navigateToChatHistory(),
                        ),
                      ),

                    if (canJoin || status == 'Selesai')
                      const SizedBox(height: 8),

                    // Detail button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (context) => CounselingDetailsBottomSheet(
                                  status: status,
                                ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getDetailButtonColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 0,
                        ),
                        child: Text(
                          'Detail',
                          style: TextStyle(
                            color: getDetailTextColor(),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
    );
  }
}
