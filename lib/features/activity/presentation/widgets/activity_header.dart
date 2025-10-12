import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class ActivityHeader extends StatelessWidget {
  const ActivityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Text('Aktivitas', style: FontTheme.subHeader),
      ),
    );
  }
}
