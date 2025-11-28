import 'package:flutter/material.dart';
import 'package:temanmu/core/bases/widgets/temani_button.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/services/router_service.dart';
import 'package:temanmu/services/shared_preference_service.dart';

class CounselingHeader extends StatelessWidget {
  final VoidCallback? onCreateSchedulePressed;

  const CounselingHeader({super.key, this.onCreateSchedulePressed});

  bool _isPeer() {
    final roles = SharedPreferencesService.getStringList(PreferencesKeys.roles);
    // Prioritize CLIENT role - if user has CLIENT role, treat as CLIENT
    // even if they also have PEER role
    if (roles != null && 
        (roles.contains('CLIENT') || roles.contains('ROLE_CLIENT'))) {
      return false;
    }
    return roles != null &&
        (roles.contains('PEER') || roles.contains('ROLE_PEER'));
  }

  @override
  Widget build(BuildContext context) {
    final isPeer = _isPeer();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buat jadwal konseling', style: FontTheme.bodySemiBold),
          const SizedBox(height: 4),
          Text(
            isPeer
                ? 'Buat jadwal konseling baru'
                : 'Ceritakan harimu pada konselor sebaya',
            style: FontTheme.textRegular.copyWith(color: BaseColors.grey),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TemaniButton(
              type: 3,
              text: "Buat Jadwal",
              onPressed: () {
                if (isPeer && onCreateSchedulePressed != null) {
                  onCreateSchedulePressed!();
                } else {
                  router.push('/book-consultation');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
