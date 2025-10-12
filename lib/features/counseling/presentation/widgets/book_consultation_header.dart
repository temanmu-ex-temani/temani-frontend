import 'package:flutter/material.dart';
import 'package:temani_frontend/services/router_service.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class BookConsultationHeader extends StatelessWidget {
  const BookConsultationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => router.pop(),
        ),
        const SizedBox(width: 48),
        Text('Buat Jadwal Konseling', style: FontTheme.bodyBold),
      ],
    );
  }
}
