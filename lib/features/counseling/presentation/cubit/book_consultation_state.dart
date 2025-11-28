import 'package:equatable/equatable.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';

abstract class BookConsultationState extends Equatable {
  const BookConsultationState();

  @override
  List<Object?> get props => [];
}

class BookConsultationInitial extends BookConsultationState {
  const BookConsultationInitial();
}

class BookConsultationLoading extends BookConsultationState {
  const BookConsultationLoading();
}

class BookConsultationLoaded extends BookConsultationState {
  final List<CounselingSchedule> allSchedules;
  final List<CounselingSchedule> filteredSchedules;
  final CounselingSchedule? selectedSchedule;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;

  const BookConsultationLoaded({
    required this.allSchedules,
    required this.filteredSchedules,
    this.selectedSchedule,
    this.startDateFilter,
    this.endDateFilter,
  });

  BookConsultationLoaded copyWith({
    List<CounselingSchedule>? allSchedules,
    List<CounselingSchedule>? filteredSchedules,
    CounselingSchedule? selectedSchedule,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    bool clearSelectedSchedule = false,
  }) {
    return BookConsultationLoaded(
      allSchedules: allSchedules ?? this.allSchedules,
      filteredSchedules: filteredSchedules ?? this.filteredSchedules,
      selectedSchedule:
          clearSelectedSchedule
              ? null
              : (selectedSchedule ?? this.selectedSchedule),
      startDateFilter: startDateFilter ?? this.startDateFilter,
      endDateFilter: endDateFilter ?? this.endDateFilter,
    );
  }

  @override
  List<Object?> get props => [
    allSchedules,
    filteredSchedules,
    selectedSchedule,
    startDateFilter,
    endDateFilter,
  ];
}

class BookConsultationError extends BookConsultationState {
  final String message;

  const BookConsultationError({required this.message});

  @override
  List<Object?> get props => [message];
}
