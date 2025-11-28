import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/constants/_constants.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/main/presentation/widgets/affirmation_card.dart';
import 'package:temanmu/features/main/presentation/widgets/home_header.dart';
import 'package:temanmu/features/mood/presentation/widgets/mood_section_real.dart';
import 'package:temanmu/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temanmu/features/main/presentation/widgets/navigation_section.dart';
import 'package:temanmu/features/main/presentation/widgets/upcoming_counseling_section.dart';
import 'package:temanmu/features/main/presentation/widgets/emergency_call_section.dart';
import 'package:temanmu/features/main/presentation/widgets/home_todo_section.dart';
import 'package:temanmu/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:temanmu/features/main/presentation/cubit/upcoming_sessions_cubit.dart';
import 'package:temanmu/services/shared_preference_service.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Refresh upcoming sessions when app comes back to foreground
      _refreshUpcomingSessions();
    }
  }

  void _refreshUpcomingSessions() {
    try {
      final upcomingSessionsCubit = GetIt.instance<UpcomingSessionsCubit>();
      upcomingSessionsCubit.loadUpcomingSessions();
    } catch (e) {
      print('Could not refresh upcoming sessions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = SharedPreferencesService.getString(
      PreferencesKeys.displayName,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetIt.instance<MoodCubit>()),
        BlocProvider(
          create: (context) =>
              GetIt.instance<TodoCubit>()..loadTodoLists(),
        ),
      ],
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
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  HomeHeader(username: username ?? 'User'),
                  SizedBox(height: 16),
                  AffirmationCard(),
                  SizedBox(height: 16),
                  MoodSectionReal(),
                  SizedBox(height: 16),
                  HomeTodoSection(),
                  SizedBox(height: 16),
                  NavigationSection(),
                  SizedBox(height: 16),
                  UpcomingCounselingSection(),
                  SizedBox(height: 16),
                  EmergencyCallSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
