import 'package:flutter/material.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_session_card.dart';

class CounselingSessionList extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  const CounselingSessionList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final session in sessions)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CounselingSessionCard(
              name: session['name'] as String,
              date: session['date'] as String,
              time: session['time'] as String,
              status: session['status'] as String,
              image: session['image'] as String,
              canJoin: session['canJoin'] as bool,
            ),
          ),
      ],
    );
  }
}
