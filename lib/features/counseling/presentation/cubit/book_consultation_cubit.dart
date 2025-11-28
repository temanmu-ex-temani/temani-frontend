import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temanmu/features/counseling/domain/repositories/counseling_schedule_repository.dart';
import 'package:temanmu/features/counseling/presentation/cubit/book_consultation_state.dart';

@injectable
class BookConsultationCubit extends Cubit<BookConsultationState> {
  final CounselingScheduleRepository repository;

  BookConsultationCubit({required this.repository})
    : super(const BookConsultationInitial());

  Future<void> loadAvailableSchedules() async {
    emit(const BookConsultationLoading());

    final result = await repository.getAvailableSchedules();

    result.fold(
      (failure) {
        emit(BookConsultationError(message: _getErrorMessage(failure)));
      },
      (schedules) {
        final filteredSchedules = _applyFilters(schedules);
        emit(
          BookConsultationLoaded(
            allSchedules: schedules,
            filteredSchedules: filteredSchedules,
          ),
        );
      },
    );
  }

  void selectSchedule(CounselingSchedule schedule) {
    final currentState = state;
    if (currentState is BookConsultationLoaded) {
      // If the same schedule is selected, deselect it
      if (currentState.selectedSchedule?.id == schedule.id) {
        emit(currentState.copyWith(clearSelectedSchedule: true));
      } else {
        // Select the new schedule
        emit(currentState.copyWith(selectedSchedule: schedule));
      }
    }
  }

  void updateDateFilter(DateTime? startDate, DateTime? endDate) {
    final currentState = state;
    if (currentState is BookConsultationLoaded) {
      final filteredSchedules = _applyFilters(
        currentState.allSchedules,
        startDate: startDate,
        endDate: endDate,
      );

      emit(
        currentState.copyWith(
          startDateFilter: startDate,
          endDateFilter: endDate,
          filteredSchedules: filteredSchedules,
        ),
      );
    }
  }

  void clearSelection() {
    final currentState = state;
    if (currentState is BookConsultationLoaded) {
      emit(currentState.copyWith(selectedSchedule: null));
    }
  }

  void clearFilters() {
    final currentState = state;
    if (currentState is BookConsultationLoaded) {
      final filteredSchedules = _applyFilters(currentState.allSchedules);

      emit(
        currentState.copyWith(
          startDateFilter: null,
          endDateFilter: null,
          filteredSchedules: filteredSchedules,
        ),
      );
    }
  }

  // Helper methods
  List<CounselingSchedule> _applyFilters(
    List<CounselingSchedule> schedules, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return schedules.where((schedule) {
        // Apply date range filter
        if (startDate != null && schedule.scheduledAt.isBefore(startDate)) {
          return false;
        }
        if (endDate != null && schedule.scheduledAt.isAfter(endDate)) {
          return false;
        }
        return true;
      }).toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  String _getErrorMessage(Failure failure) {
    // Since we only have a generic Failure class, we'll use the message directly
    // or provide a generic error message
    return failure.message.isNotEmpty
        ? failure.message
        : 'Terjadi kesalahan yang tidak diketahui. Silakan coba lagi.';
  }
}
