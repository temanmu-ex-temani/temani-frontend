import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/presentation/cubit/counseling_sessions_cubit.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_header.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_tab_bar.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/counseling_session_list.dart';
import 'package:temani_frontend/services/depedencies/di.dart';

class CounselingPage extends StatefulWidget {
  const CounselingPage({super.key});

  @override
  State<CounselingPage> createState() => _CounselingPageState();
}

class _CounselingPageState extends State<CounselingPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    // Get cubit from dependency injection
    final cubit = get<CounselingSessionsCubit>();

    // Load counseling sessions when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadCounselingSessions();
    });

    return BlocProvider.value(
      value: cubit,
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
                      child: Text("Counseling", style: FontTheme.subHeader),
                    ),
                    SizedBox(height: 16),
                    CounselingHeader(),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.errorMessage ?? 'An error occurred',
                              ),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status == CounselingSessionsStatus.loading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final filteredSessions = context
                            .read<CounselingSessionsCubit>()
                            .getFilteredSessions(selectedTab);

                        if (filteredSessions.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Tidak ada sesi konseling',
                                    style: TextStyle(
                                      fontSize: 16,
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
