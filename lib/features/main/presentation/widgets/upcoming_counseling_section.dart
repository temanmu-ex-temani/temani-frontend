import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_session_card.dart';

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
          CounselingSessionCard(
            name: 'Chika',
            date: 'Rabu, 2 Juli 2025',
            time: '19:00 - 20:00',
            status: 'Terjadwal',
            image: 'assets/doctor.jpg',
            canJoin: false,
          ),
        ],
      ),
    );
  }
}
