import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temani_frontend/features/counseling/domain/repositories/counseling_schedule_repository.dart';

part 'counseling_sessions_state.dart';

@injectable
class CounselingSessionsCubit extends Cubit<CounselingSessionsState> {
  final CounselingScheduleRepository _repository;

  CounselingSessionsCubit({required CounselingScheduleRepository repository})
    : _repository = repository,
      super(const CounselingSessionsState());

  Future<void> loadCounselingSessions() async {
    emit(state.copyWith(status: CounselingSessionsStatus.loading));

    final result = await _repository.getCounselingSchedules(
      status: ['PENDING', 'SCHEDULED', 'ONGOING', 'COMPLETED', 'CANCELLED'],
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CounselingSessionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (sessions) => emit(
        state.copyWith(
          status: CounselingSessionsStatus.success,
          allSessions: sessions,
        ),
      ),
    );
  }

  List<CounselingSchedule> getFilteredSessions(int selectedTab) {
    switch (selectedTab) {
      case 1: // Berjalan: PENDING, SCHEDULED, ONGOING
        return state.allSessions
            .where(
              (s) => ['PENDING', 'SCHEDULED', 'ONGOING'].contains(s.status),
            )
            .toList();
      case 2: // Selesai: COMPLETED
        return state.allSessions.where((s) => s.status == 'COMPLETED').toList();
      case 3: // Dibatalkan: CANCELLED
        return state.allSessions.where((s) => s.status == 'CANCELLED').toList();
      default: // Semua
        return state.allSessions;
    }
  }

  String getLocalizedStatus(String status) {
    switch (status) {
      case 'PENDING':
        return 'Terjadwal';
      case 'SCHEDULED':
        return 'Terjadwal';
      case 'ONGOING':
        return 'Berlangsung';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  bool canJoinSession(String status) {
    return status == 'ONGOING';
  }
}
