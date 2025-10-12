import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/services/router_service.dart';

class NavigationSection extends StatelessWidget {
  const NavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => router.push('/journal'),
            child: _NavCard(
              title: 'Tulis jurnal harian',
              icon: PhosphorIcons.bookOpen(),
              iconColor: BaseColors.orange.shade500,
              bgColor: BaseColors.orange.shade100,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => router.push('/book-consultation'),
            child: _NavCard(
              title: 'Buat jadwal konseling',
              icon: PhosphorIcons.calendarBlank(),
              iconColor: BaseColors.info.shade500,
              bgColor: BaseColors.info.shade100,
            ),
          ),
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const _NavCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -5,
            bottom: -5,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Center(child: Icon(icon, color: iconColor, size: 28)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(64, 0, 0, 32),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: FontTheme.textMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
