import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_header.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_history_list.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/activity_filter_buttons.dart';
import 'package:temani_frontend/features/activity/presentation/widgets/mood_summary_real.dart';
import 'package:temani_frontend/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:temani_frontend/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late final ActivityCubit _activityCubit;
  late final MoodCubit _moodCubit;

  @override
  void initState() {
    super.initState();
    _activityCubit = GetIt.instance<ActivityCubit>();
    _moodCubit = GetIt.instance<MoodCubit>();
    _activityCubit.loadAllActivities();
    _moodCubit.loadMoodSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0.00, 1.00),
            colors: [
              BaseColors.info.shade50,
              BaseColors.cyan.shade50,
              BaseColors.success.shade50,
            ],
            stops: const [0, 0.5, 1],
            transform: GradientRotation(169 * 3.14159 / 180),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ActivityHeader(),
                const SizedBox(height: 16),
                BlocProvider.value(
                  value: _moodCubit,
                  child: const MoodSummaryReal(),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ActivityCubit, ActivityState>(
                  bloc: _activityCubit,
                  builder: (context, state) {
                    return Column(
                      children: [
                        ActivityFilterButtons(
                          selectedFeature: state.selectedFeature,
                          onFeatureSelected: (feature) {
                            if (feature == 'all') {
                              _activityCubit.filterByFeature('all');
                            } else {
                              _activityCubit.filterByFeature(feature);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        ActivityHistoryList(
                          activities: state.filteredActivities,
                          cubit: _activityCubit,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
