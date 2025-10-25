part of 'mood_cubit.dart';

enum MoodStatus { initial, loading, success, error }

class MoodState extends Equatable {
  final MoodStatus status;
  final List<MoodLog> moodLogs;
  final MoodSummary? moodSummary;
  final String errorMessage;

  const MoodState({
    this.status = MoodStatus.initial,
    this.moodLogs = const [],
    this.moodSummary,
    this.errorMessage = '',
  });

  MoodState copyWith({
    MoodStatus? status,
    List<MoodLog>? moodLogs,
    MoodSummary? moodSummary,
    String? errorMessage,
  }) {
    return MoodState(
      status: status ?? this.status,
      moodLogs: moodLogs ?? this.moodLogs,
      moodSummary: moodSummary ?? this.moodSummary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, moodLogs, moodSummary, errorMessage];
}
