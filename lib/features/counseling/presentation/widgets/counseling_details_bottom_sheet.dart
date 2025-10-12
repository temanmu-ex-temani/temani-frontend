import 'package:flutter/material.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/services/router_service.dart';

class CounselingDetailsBottomSheet extends StatelessWidget {
  final String status; // 'Terjadwal', 'Berlangsung', 'Selesai', 'Dibatalkan'
  const CounselingDetailsBottomSheet({super.key, required this.status});

  Color getStatusColor() {
    switch (status) {
      case 'Terjadwal':
        return BaseColors.info.shade50;
      case 'Berlangsung':
        return BaseColors.orange.shade50;
      case 'Selesai':
        return BaseColors.success.shade50;
      case 'Dibatalkan':
        return BaseColors.error.shade50;
      default:
        return BaseColors.info.shade50;
    }
  }

  Color getStatusTextColor() {
    switch (status) {
      case 'Terjadwal':
        return BaseColors.info.shade400;
      case 'Berlangsung':
        return BaseColors.orange.shade400;
      case 'Selesai':
        return BaseColors.success.shade400;
      case 'Dibatalkan':
        return BaseColors.error.shade400;
      default:
        return BaseColors.info.shade400;
    }
  }

  Color getStatusBorderColor() {
    switch (status) {
      case 'Terjadwal':
        return BaseColors.info.shade300;
      case 'Berlangsung':
        return BaseColors.orange.shade300;
      case 'Selesai':
        return BaseColors.success.shade300;
      case 'Dibatalkan':
        return BaseColors.error.shade300;
      default:
        return BaseColors.info.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status sesi', style: FontTheme.textMedium),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: getStatusColor(),
              border: Border.all(color: getStatusBorderColor()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                status,
                style: FontTheme.textMedium.copyWith(
                  color: getStatusTextColor(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Konselor', style: FontTheme.textMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/doctor.jpg',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chika', style: FontTheme.textMedium),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              color: Color(0xFFFFA800),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('4.9', style: FontTheme.captionRegular),
                        ],
                      ),
                      Text('500+ Reviews', style: FontTheme.captionRegular),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Detail sesi', style: FontTheme.textMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                PhosphorIcons.user(),
                size: 18,
                color: BaseColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text('ID: UXBCY-JDKSD-B73OM', style: FontTheme.captionRegular),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                PhosphorIcons.calendarBlank(),
                size: 18,
                color: BaseColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text('Rabu, 2 Juli 2025', style: FontTheme.captionRegular),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                PhosphorIcons.clock(),
                size: 18,
                color: BaseColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text('20:00 - 21:00', style: FontTheme.captionRegular),
            ],
          ),
          const SizedBox(height: 22),
          _buildButtonSection(context),
        ],
      ),
    );
  }

  Widget _buildButtonSection(BuildContext context) {
    switch (status) {
      case 'Berlangsung':
        return Row(
          children: [
            Expanded(
              child: TemaniButton(
                type: 3,
                text: 'Gabung Sesi',
                onPressed: () => router.push('/chat'),
              ),
            ),
          ],
        );
      case 'Terjadwal':
        return Row(
          children: [
            Expanded(child: TemaniButton(type: 1, text: 'Ubah Jadwal')),
            const SizedBox(width: 12),
            Expanded(child: TemaniButton(type: 2, text: 'Batalkan')),
          ],
        );
      case 'Selesai':
        return Row(
          children: [
            Expanded(child: TemaniButton(type: 1, text: 'Beri Ulasan')),
          ],
        );
      case 'Dibatalkan':
        return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _PrimaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: BaseColors.info.shade100,
          foregroundColor: BaseColors.info.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text, style: FontTheme.textMedium),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const _SecondaryButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: BaseColors.error.shade400,
          side: BorderSide(color: BaseColors.error.shade100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: FontTheme.textMedium.copyWith(
            color: BaseColors.error.shade400,
          ),
        ),
      ),
    );
  }
}
