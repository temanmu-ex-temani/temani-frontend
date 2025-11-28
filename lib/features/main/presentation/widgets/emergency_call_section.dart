import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/themes/_themes.dart';

class EmergencyCallSection extends StatelessWidget {
  const EmergencyCallSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFF6467), Color(0xFFFB64B6)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh bantuan segera?',
                  style: FontTheme.bodySemiBold.copyWith(color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Hubungi kontak darurat!',
                  style: FontTheme.captionRegular.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.phone(),
                  color: BaseColors.rose.shade400,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Hubungi',
                  style: FontTheme.captionBold.copyWith(
                    color: BaseColors.rose.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
