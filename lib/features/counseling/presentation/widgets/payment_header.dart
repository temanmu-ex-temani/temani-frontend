import 'package:flutter/material.dart';
import 'package:temanmu/services/router_service.dart';

class PaymentHeader extends StatelessWidget {
  const PaymentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => router.pop(),
        ),
        const SizedBox(width: 48),
        Text(
          'Buat Jadwal Konseling',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}
