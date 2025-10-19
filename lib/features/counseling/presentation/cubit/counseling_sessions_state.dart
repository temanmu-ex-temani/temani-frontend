part of 'counseling_sessions_cubit.dart';

enum CounselingSessionsStatus { initial, loading, success, error }

class CounselingSessionsState extends Equatable {
  final CounselingSessionsStatus status;
  final List<CounselingSchedule> allSessions;
  final String? errorMessage;

  const CounselingSessionsState({
    this.status = CounselingSessionsStatus.initial,
    this.allSessions = const [],
    this.errorMessage,
  });

  CounselingSessionsState copyWith({
    CounselingSessionsStatus? status,
    List<CounselingSchedule>? allSessions,
    String? errorMessage,
  }) {
    return CounselingSessionsState(
      status: status ?? this.status,
      allSessions: allSessions ?? this.allSessions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, allSessions, errorMessage];
}
