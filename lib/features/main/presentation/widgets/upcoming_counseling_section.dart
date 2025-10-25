import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/main/presentation/cubit/upcoming_sessions_cubit.dart';
import 'package:temani_frontend/features/main/presentation/widgets/counseling_session_list.dart';
import 'package:temani_frontend/services/depedencies/di.dart';

class UpcomingCounselingSection extends StatelessWidget {
  const UpcomingCounselingSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Get cubit from dependency injection
    final cubit = get<UpcomingSessionsCubit>();

    // Load upcoming sessions when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadUpcomingSessions();
    });

    return BlocProvider.value(
      value: cubit,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BaseColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sesi konseling mendatang', style: FontTheme.textMedium),
            SizedBox(height: 12),
            BlocBuilder<UpcomingSessionsCubit, UpcomingSessionsState>(
              builder: (context, state) {
                if (state.status == UpcomingSessionsStatus.loading) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.status == UpcomingSessionsStatus.error) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Gagal memuat sesi konseling',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (state.upcomingSessions.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Tidak ada sesi konseling mendatang',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return CounselingSessionList(sessions: state.upcomingSessions);
              },
            ),
          ],
        ),
      ),
    );
  }
}
