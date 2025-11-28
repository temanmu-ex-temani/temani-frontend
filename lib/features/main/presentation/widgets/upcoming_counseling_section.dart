import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/main/presentation/cubit/upcoming_sessions_cubit.dart';
import 'package:temanmu/features/main/presentation/widgets/counseling_session_list.dart';
import 'package:temanmu/services/depedencies/di.dart';

class UpcomingCounselingSection extends StatefulWidget {
  const UpcomingCounselingSection({super.key});

  @override
  State<UpcomingCounselingSection> createState() => _UpcomingCounselingSectionState();
}

class _UpcomingCounselingSectionState extends State<UpcomingCounselingSection> with WidgetsBindingObserver {
  late final UpcomingSessionsCubit _cubit;
  bool _hasLoaded = false;
  DateTime? _lastRefreshTime;

  @override
  void initState() {
    super.initState();
    _cubit = get<UpcomingSessionsCubit>();
    WidgetsBinding.instance.addObserver(this);
    // Load upcoming sessions when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasLoaded) {
        _cubit.loadUpcomingSessions();
        _hasLoaded = true;
        _lastRefreshTime = DateTime.now();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app comes back to foreground
    if (state == AppLifecycleState.resumed && _hasLoaded && mounted) {
      _refreshIfNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when the widget becomes visible again (e.g., when navigating back from chat)
    // Only refresh if it's been more than 1 second since last refresh to avoid excessive calls
    if (_hasLoaded && mounted) {
      _refreshIfNeeded();
    }
  }

  void _refreshIfNeeded() {
    final now = DateTime.now();
    // Only refresh if it's been more than 1 second since last refresh
    if (_lastRefreshTime == null || 
        now.difference(_lastRefreshTime!).inSeconds > 1) {
      _lastRefreshTime = now;
      // Use a small delay to ensure the route transition is complete
      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          _cubit.loadUpcomingSessions();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<UpcomingSessionsCubit, UpcomingSessionsState>(
        listener: (context, state) {
          // This ensures we're listening to state changes
          // The BlocBuilder below will rebuild automatically
        },
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
                buildWhen: (previous, current) {
                  // Always rebuild to ensure we show the latest data
                  // The buildWhen check might be too strict, so let's rebuild on any state change
                  return true; // Rebuild on any state change
                },
                builder: (context, state) {
                  // Debug: Print state changes
                  print('[UpcomingCounselingSection] State changed: ${state.status}, Sessions: ${state.upcomingSessions.length}');
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
      ),
    );
  }
}
