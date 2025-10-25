import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:temani_frontend/features/activity/domain/entities/activity.dart';
import 'package:temani_frontend/features/activity/domain/repositories/activity_repository.dart';

part 'activity_state.dart';

@injectable
class ActivityCubit extends Cubit<ActivityState> {
  final ActivityRepository _repository;

  ActivityCubit({required ActivityRepository repository})
      : _repository = repository,
        super(const ActivityState());

  Future<void> loadAllActivities() async {
    emit(state.copyWith(status: ActivityStatus.loading));

    final result = await _repository.getAllActivities();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ActivityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (activities) => emit(
        state.copyWith(
          status: ActivityStatus.success,
          allActivities: activities,
          filteredActivities: activities,
          selectedFeature: 'all',
        ),
      ),
    );
  }

  Future<void> loadActivitiesByFeature(String feature) async {
    emit(state.copyWith(status: ActivityStatus.loading));

    final result = await _repository.getActivitiesByFeature(feature);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ActivityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (activities) => emit(
        state.copyWith(
          status: ActivityStatus.success,
          filteredActivities: activities,
          selectedFeature: feature,
        ),
      ),
    );
  }

  Future<void> createTestActivity() async {
    emit(state.copyWith(status: ActivityStatus.loading));

    final result = await _repository.createTestActivity();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ActivityStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (activities) => emit(
        state.copyWith(
          status: ActivityStatus.success,
          allActivities: [...state.allActivities, ...activities],
          filteredActivities: [...state.filteredActivities, ...activities],
        ),
      ),
    );
  }

  void filterByFeature(String feature) {
    if (feature == 'all') {
      emit(state.copyWith(
        filteredActivities: state.allActivities,
        selectedFeature: 'all',
      ));
    } else {
      final filtered = state.allActivities
          .where((activity) => activity.feature == feature)
          .toList();
      emit(state.copyWith(
        filteredActivities: filtered,
        selectedFeature: feature,
      ));
    }
  }

  String getActivityIcon(String feature) {
    switch (feature) {
      case 'journal':
        return '📝';
      case 'moodlog':
        return '😊';
      case 'todo':
        return '✅';
      case 'counseling':
        return '💬';
      case 'relationship':
        return '👥';
      case 'payment':
        return '💳';
      default:
        return '📋';
    }
  }

  String getActivityTitle(String feature, String action) {
    switch (feature) {
      case 'journal':
        return action == 'create' ? 'Menulis Journal' : 'Mengupdate Journal';
      case 'moodlog':
        return 'Mengisi Mood Tracker';
      case 'todo':
        return action == 'create' ? 'Membuat Todo Item' : 'Mengupdate Todo';
      case 'counseling':
        return 'Melakukan Konseling';
      case 'relationship':
        return 'Mengelola Relasi';
      case 'payment':
        return 'Pembayaran';
      default:
        return 'Aktivitas';
    }
  }
}
