import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';

class PaymentSummary extends StatelessWidget {
  final CounselingSchedule? schedule;

  const PaymentSummary({super.key, this.schedule});

  @override
  Widget build(BuildContext context) {
    // Default pricing (you might want to get this from the schedule or a service)
    const double sessionPrice = 30000.0;
    const double serviceFee = 5000.0;
    const double total = sessionPrice + serviceFee;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_rounded,
                color: BaseColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Ringkasan Pembayaran',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.neutral.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                schedule?.title ?? 'Sesi Konseling',
                style: FontTheme.captionMedium.copyWith(
                  color: BaseColors.neutral.shade700,
                ),
              ),
              Text(
                'Rp${sessionPrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: FontTheme.captionSemiBold.copyWith(
                  color: BaseColors.neutral.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Layanan',
                style: FontTheme.captionMedium.copyWith(
                  color: BaseColors.neutral.shade700,
                ),
              ),
              Text(
                'Rp${serviceFee.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: FontTheme.captionSemiBold.copyWith(
                  color: BaseColors.neutral.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: BaseColors.neutral.shade200),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.neutral.shade900,
                ),
              ),
              Text(
                'Rp${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: FontTheme.bodySemiBold.copyWith(
                  color: BaseColors.secondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
