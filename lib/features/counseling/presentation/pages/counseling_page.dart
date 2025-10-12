import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_header.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_tab_bar.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_session_list.dart';

class CounselingPage extends StatefulWidget {
  const CounselingPage({super.key});

  @override
  State<CounselingPage> createState() => _CounselingPageState();
}

class _CounselingPageState extends State<CounselingPage> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> sessions = [
    {
      'name': 'Chika',
      'date': 'Rabu, 2 Juli 2025',
      'time': '19:00 - 20:00',
      'status': 'Terjadwal',
      'image': 'assets/doctor.jpg',
      'canJoin': false,
    },
    {
      'name': 'Chika',
      'date': 'Rabu, 2 Juli 2025',
      'time': '19:00 - 20:00',
      'status': 'Berlangsung',
      'image': 'assets/doctor.jpg',
      'canJoin': true,
    },
    {
      'name': 'Chika',
      'date': 'Rabu, 2 Juli 2025',
      'time': '19:00 - 20:00',
      'status': 'Selesai',
      'image': 'assets/doctor.jpg',
      'canJoin': false,
    },
    {
      'name': 'Chika',
      'date': 'Rabu, 2 Juli 2025',
      'time': '19:00 - 20:00',
      'status': 'Dibatalkan',
      'image': 'assets/doctor.jpg',
      'canJoin': false,
    },
  ];

  List<Map<String, dynamic>> get filteredSessions {
    switch (selectedTab) {
      case 1:
        // Berjalan: Terjadwal & Berlangsung
        return sessions
            .where(
              (s) => s['status'] == 'Terjadwal' || s['status'] == 'Berlangsung',
            )
            .toList();
      case 2:
        // Selesai
        return sessions.where((s) => s['status'] == 'Selesai').toList();
      case 3:
        // Dibatalkan
        return sessions.where((s) => s['status'] == 'Dibatalkan').toList();
      default:
        // Semua
        return sessions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0.00, 1.00),
            colors: [
              BaseColors.info.shade50,
              BaseColors.cyan.shade50,
              BaseColors.success.shade50,
            ],
            stops: [0, 0.5, 1],
            transform: GradientRotation(169 * 3.14159 / 180),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Text("Counseling", style: FontTheme.subHeader)),
                  SizedBox(height: 16),
                  CounselingHeader(),
                  SizedBox(height: 16),
                  Text(
                    'Riwayat konselingmu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  CounselingTabBar(
                    selectedIndex: selectedTab,
                    onTabChanged: (i) => setState(() => selectedTab = i),
                  ),
                  SizedBox(height: 16),
                  CounselingSessionList(sessions: filteredSessions),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
