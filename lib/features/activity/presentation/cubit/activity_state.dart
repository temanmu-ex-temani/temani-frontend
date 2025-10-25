part of 'activity_cubit.dart';

enum ActivityStatus { initial, loading, success, error }

class ActivityState extends Equatable {
  final ActivityStatus status;
  final List<Activity> allActivities;
  final List<Activity> filteredActivities;
  final String selectedFeature;
  final String errorMessage;

  const ActivityState({
    this.status = ActivityStatus.initial,
    this.allActivities = const [],
    this.filteredActivities = const [],
    this.selectedFeature = 'all',
    this.errorMessage = '',
  });

  ActivityState copyWith({
    ActivityStatus? status,
    List<Activity>? allActivities,
    List<Activity>? filteredActivities,
    String? selectedFeature,
    String? errorMessage,
  }) {
    return ActivityState(
      status: status ?? this.status,
      allActivities: allActivities ?? this.allActivities,
      filteredActivities: filteredActivities ?? this.filteredActivities,
      selectedFeature: selectedFeature ?? this.selectedFeature,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allActivities,
        filteredActivities,
        selectedFeature,
        errorMessage,
      ];
}
