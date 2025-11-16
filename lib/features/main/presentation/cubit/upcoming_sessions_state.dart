part of 'upcoming_sessions_cubit.dart';

enum UpcomingSessionsStatus { initial, loading, success, error }

class UpcomingSessionsState extends Equatable {
  final UpcomingSessionsStatus status;
  final List<CounselingSchedule> upcomingSessions;
  final String? errorMessage;

  const UpcomingSessionsState({
    this.status = UpcomingSessionsStatus.initial,
    this.upcomingSessions = const [],
    this.errorMessage,
  });

  UpcomingSessionsState copyWith({
    UpcomingSessionsStatus? status,
    List<CounselingSchedule>? upcomingSessions,
    String? errorMessage,
  }) {
    return UpcomingSessionsState(
      status: status ?? this.status,
      upcomingSessions: upcomingSessions ?? this.upcomingSessions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, upcomingSessions, errorMessage];
}







