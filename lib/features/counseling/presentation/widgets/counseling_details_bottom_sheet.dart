import 'package:flutter/material.dart';
import 'package:temanmu/core/bases/widgets/temanmu_button.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/services/router_service.dart';

class CounselingDetailsBottomSheet extends StatelessWidget {
  final String status; // 'Terjadwal', 'Berlangsung', 'Selesai', 'Dibatalkan'
  final String title;
  final String counselorName;
  final String? clientName;
  final String date;
  final String time;
  final String? description;
  final String? meetingLink;
  final String? notes;
  final String id;
  final bool showClientName;
  
  const CounselingDetailsBottomSheet({
    super.key,
    required this.status,
    required this.title,
    required this.counselorName,
    this.clientName,
    required this.date,
    required this.time,
    this.description,
    this.meetingLink,
    this.notes,
    required this.id,
    this.showClientName = false,
  });

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
          Text('Judul Sesi', style: FontTheme.textMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: Text(
              title,
              style: FontTheme.textMedium,
            ),
          ),
          const SizedBox(height: 18),
          Text(showClientName ? 'Klien' : 'Konselor', style: FontTheme.textMedium),
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
                      Text(
                        showClientName 
                            ? (clientName ?? '-') 
                            : counselorName,
                        style: FontTheme.textMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Detail sesi', style: FontTheme.textMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BaseColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.calendarBlank(),
                      size: 18,
                      color: BaseColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(date, style: FontTheme.captionRegular),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.clock(),
                      size: 18,
                      color: BaseColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(time, style: FontTheme.captionRegular),
                  ],
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Deskripsi:',
                    style: FontTheme.captionMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: FontTheme.captionRegular,
                  ),
                ],
                if (meetingLink != null && meetingLink!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.link(),
                        size: 18,
                        color: BaseColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          meetingLink!,
                          style: FontTheme.captionRegular.copyWith(
                            color: BaseColors.info.shade600,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (notes != null && notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Catatan:',
                    style: FontTheme.captionMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notes!,
                    style: FontTheme.captionRegular,
                  ),
                ],
              ],
            ),
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
              child: TemanMuButton(
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
            Expanded(child: TemanMuButton(type: 1, text: 'Ubah Jadwal')),
            const SizedBox(width: 12),
            Expanded(child: TemanMuButton(type: 2, text: 'Batalkan')),
          ],
        );
      case 'Selesai':
        return SizedBox.shrink();
      case 'Dibatalkan':
        return SizedBox.shrink();
      default:
        return SizedBox.shrink();
    }
  }
}

