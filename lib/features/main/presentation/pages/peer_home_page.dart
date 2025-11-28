import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temanmu/features/counseling/presentation/cubit/counseling_sessions_cubit.dart';
import 'package:temanmu/features/counseling/presentation/widgets/counseling_header.dart';
import 'package:temanmu/features/counseling/presentation/widgets/counseling_tab_bar.dart';
import 'package:temanmu/features/counseling/presentation/widgets/counseling_session_list.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'package:temanmu/services/router_service.dart';
import 'package:temanmu/services/toast_service.dart';

class PeerHomePage extends StatefulWidget {
  const PeerHomePage({super.key});

  @override
  State<PeerHomePage> createState() => _PeerHomePageState();
}

class _PeerHomePageState extends State<PeerHomePage> {
  int selectedTab = 0;
  late final CounselingSessionsCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Get cubit instance once and store it
    _cubit = get<CounselingSessionsCubit>();
    // Load peer counseling sessions when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadPeerCounselingSessions();
    });
  }

  Future<void> _navigateToCreateSchedule() async {
    final result = await router.push('/create-schedule');
    // If schedule was created successfully, refresh the list
    if (result == true && mounted) {
      _cubit.loadPeerCounselingSessions();
    }
  }

  @override
  void dispose() {
    // Don't dispose the cubit as it's managed by DI
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
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
                    Center(
                      child: Text("Beranda", style: FontTheme.subHeader),
                    ),
                    SizedBox(height: 16),
                    CounselingHeader(
                      onCreateSchedulePressed: _navigateToCreateSchedule,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Riwayat konselingmu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    CounselingTabBar(
                      selectedIndex: selectedTab,
                      onTabChanged: (i) => setState(() => selectedTab = i),
                    ),
                    SizedBox(height: 16),
                    BlocConsumer<
                        CounselingSessionsCubit,
                        CounselingSessionsState
                    >(
                      listener: (context, state) {
                        if (state.status == CounselingSessionsStatus.error) {
                          ToastService.show(
                            context,
                            state.errorMessage ?? 'Terjadi kesalahan',
                          );
                        }
                      },
                      builder: (context, state) {
                        print('PeerHomePage - State status: ${state.status}');
                        print('PeerHomePage - All sessions count: ${state.allSessions.length}');
                        print('PeerHomePage - Cubit instance: ${_cubit.hashCode}');
                        
                        // Show loading only if loading and no sessions yet
                        if (state.status == CounselingSessionsStatus.loading && 
                            state.allSessions.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state.status == CounselingSessionsStatus.error) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Error: ${state.errorMessage ?? "Unknown error"}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Filter sessions based on selected tab using the state from builder
                        List<CounselingSchedule> filteredSessions;
                        switch (selectedTab) {
                          case 1: // Berjalan: PENDING, SCHEDULED, ONGOING
                            filteredSessions = state.allSessions
                                .where(
                                  (s) => ['PENDING', 'SCHEDULED', 'ONGOING'].contains(s.status),
                                )
                                .toList();
                            break;
                          case 2: // Selesai: COMPLETED
                            filteredSessions = state.allSessions
                                .where((s) => s.status == 'COMPLETED')
                                .toList();
                            break;
                          case 3: // Dibatalkan: CANCELLED
                            filteredSessions = state.allSessions
                                .where((s) => s.status == 'CANCELLED')
                                .toList();
                            break;
                          default: // Semua (including AVAILABLE)
                            filteredSessions = state.allSessions;
                        }

                        print('PeerHomePage - Filtered sessions count: ${filteredSessions.length}');
                        print('PeerHomePage - Selected tab: $selectedTab');
                        print('PeerHomePage - All sessions statuses: ${state.allSessions.map((s) => s.status).toList()}');

                        if (filteredSessions.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak ada sesi konseling',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Total: ${state.allSessions.length} sessions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return CounselingSessionList(
                          sessions: filteredSessions,
                          showClientName: true, // Show client name for PEER role
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

