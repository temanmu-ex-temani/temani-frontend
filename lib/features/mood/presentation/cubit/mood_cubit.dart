import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:temanmu/features/mood/domain/entities/mood_log.dart';
import 'package:temanmu/features/mood/domain/entities/mood_summary.dart';
import 'package:temanmu/features/mood/domain/repositories/mood_repository.dart';

part 'mood_state.dart';

@injectable
class MoodCubit extends Cubit<MoodState> {
  final MoodRepository _repository;

  MoodCubit({required MoodRepository repository})
    : _repository = repository,
      super(const MoodState());

  Future<void> loadMoodLogs() async {
    emit(state.copyWith(status: MoodStatus.loading));

    final result = await _repository.getAllMoodLogs();

    result.fold(
      (failure) => emit(
        state.copyWith(status: MoodStatus.error, errorMessage: failure.message),
      ),
      (moodLogs) =>
          emit(state.copyWith(status: MoodStatus.success, moodLogs: moodLogs)),
    );
  }

  Future<void> createMoodLog({
    required String moodVisual,
    required int emotionScale,
  }) async {
    emit(state.copyWith(status: MoodStatus.loading));

    final result = await _repository.createMoodLog(
      moodVisual: moodVisual,
      emotionScale: emotionScale,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: MoodStatus.error, errorMessage: failure.message),
      ),
      (moodLog) => emit(
        state.copyWith(
          status: MoodStatus.success,
          moodLogs: [moodLog, ...state.moodLogs],
        ),
      ),
    );
  }

  Future<void> updateMoodLog({
    required String id,
    required String moodVisual,
    required int emotionScale,
  }) async {
    emit(state.copyWith(status: MoodStatus.loading));

    final result = await _repository.updateMoodLog(
      id: id,
      moodVisual: moodVisual,
      emotionScale: emotionScale,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: MoodStatus.error, errorMessage: failure.message),
      ),
      (updatedMoodLog) => emit(
        state.copyWith(
          status: MoodStatus.success,
          moodLogs:
              state.moodLogs.map((log) {
                return log.id == id ? updatedMoodLog : log;
              }).toList(),
        ),
      ),
    );
  }

  Future<void> deleteMoodLog(String id) async {
    emit(state.copyWith(status: MoodStatus.loading));

    final result = await _repository.deleteMoodLog(id);

    result.fold(
      (failure) => emit(
        state.copyWith(status: MoodStatus.error, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          status: MoodStatus.success,
          moodLogs: state.moodLogs.where((log) => log.id != id).toList(),
        ),
      ),
    );
  }

  // Helper methods for mood data
  String getMoodVisualFromScale(int scale) {
    switch (scale) {
      case 1:
        return 'sangat buruk';
      case 2:
        return 'buruk';
      case 3:
        return 'biasa saja';
      case 4:
        return 'baik';
      case 5:
        return 'sangat baik';
      default:
        return 'biasa saja';
    }
  }

  int getScaleFromMoodVisual(String moodVisual) {
    switch (moodVisual) {
      case 'sangat buruk':
        return 1;
      case 'buruk':
        return 2;
      case 'biasa saja':
        return 3;
      case 'baik':
        return 4;
      case 'sangat baik':
        return 5;
      default:
        return 3;
    }
  }

  DateTime get currentWeekStart => _startOfWeek(DateTime.now());

  bool get canNavigateForward {
    final selected = state.selectedWeekStart ?? currentWeekStart;
    return selected.isBefore(currentWeekStart);
  }

  Future<void> loadMoodSummary({DateTime? weekStart}) async {
    final targetWeekStart = _startOfWeek(
      weekStart ?? state.selectedWeekStart ?? currentWeekStart,
    );

    emit(
      state.copyWith(
        status: MoodStatus.loading,
        selectedWeekStart: targetWeekStart,
      ),
    );

    final formattedWeekStart = DateFormat('yyyy-MM-dd').format(targetWeekStart);
    final result = await _repository.getMoodSummary(
      weekStart: formattedWeekStart,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MoodStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (moodSummary) {
        final responseWeekStart = _parseWeekStart(moodSummary.weekStart) ??
            targetWeekStart;
        emit(
          state.copyWith(
            status: MoodStatus.success,
            moodSummary: moodSummary,
            selectedWeekStart: responseWeekStart,
            errorMessage: '',
          ),
        );
      },
    );
  }

  Future<void> loadMoodSummaryByUserId(
    String userId, {
    DateTime? weekStart,
  }) async {
    final targetWeekStart = _startOfWeek(
      weekStart ?? state.selectedWeekStart ?? currentWeekStart,
    );

    emit(
      state.copyWith(
        status: MoodStatus.loading,
        selectedWeekStart: targetWeekStart,
      ),
    );

    final formattedWeekStart = DateFormat('yyyy-MM-dd').format(targetWeekStart);
    final result = await _repository.getMoodSummaryByUserId(
      userId,
      weekStart: formattedWeekStart,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MoodStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (moodSummary) {
        final responseWeekStart = _parseWeekStart(moodSummary.weekStart) ??
            targetWeekStart;
        emit(
          state.copyWith(
            status: MoodStatus.success,
            moodSummary: moodSummary,
            selectedWeekStart: responseWeekStart,
            errorMessage: '',
          ),
        );
      },
    );
  }

  void loadPreviousWeek() {
    final base = state.selectedWeekStart ?? currentWeekStart;
    final previousWeek = base.subtract(const Duration(days: 7));
    loadMoodSummary(weekStart: previousWeek);
  }

  void loadNextWeek() {
    final base = state.selectedWeekStart ?? currentWeekStart;
    if (!base.isBefore(currentWeekStart)) return;
    final nextWeek = base.add(const Duration(days: 7));
    if (nextWeek.isAfter(currentWeekStart)) {
      loadMoodSummary(weekStart: currentWeekStart);
    } else {
      loadMoodSummary(weekStart: nextWeek);
    }
  }

  void loadSummaryForDate(DateTime date) {
    loadMoodSummary(weekStart: date);
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final difference = normalized.weekday - DateTime.monday;
    return normalized.subtract(Duration(days: difference));
  }

  DateTime? _parseWeekStart(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  // Get today's mood log if it exists
  MoodLog? getTodayMoodLog() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    try {
      return state.moodLogs.firstWhere(
        (log) =>
            log.timestamp.isAfter(todayStart) &&
            log.timestamp.isBefore(todayEnd),
      );
    } catch (e) {
      return null;
    }
  }

  // Get mood logs for the last 7 days
  List<MoodLog> getLastWeekMoodLogs() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    return state.moodLogs
        .where((log) => log.timestamp.isAfter(weekAgo))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Calculate average mood for the last 7 days
  double getAverageMood() {
    final weekLogs = getLastWeekMoodLogs();
    if (weekLogs.isEmpty) return 0.0;

    final total = weekLogs.fold(0, (sum, log) => sum + log.emotionScale);
    return total / weekLogs.length;
  }
}
