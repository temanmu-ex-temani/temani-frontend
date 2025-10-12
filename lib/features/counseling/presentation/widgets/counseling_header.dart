import 'package:flutter/material.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/services/router_service.dart';

class CounselingHeader extends StatelessWidget {
  const CounselingHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
            'Ceritakan harimu pada konselor sebaya',
            style: FontTheme.textRegular.copyWith(color: BaseColors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TemaniButton(
                  type: 3,
                  text: "Buat Jadwal",
                  onPressed: () => router.push('/book-consultation'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
