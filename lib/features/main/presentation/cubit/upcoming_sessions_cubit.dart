import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temani_frontend/features/counseling/domain/repositories/counseling_schedule_repository.dart';

part 'upcoming_sessions_state.dart';

@injectable
class UpcomingSessionsCubit extends Cubit<UpcomingSessionsState> {
  final CounselingScheduleRepository _repository;

  UpcomingSessionsCubit({required CounselingScheduleRepository repository})
    : _repository = repository,
      super(const UpcomingSessionsState());

  Future<void> loadUpcomingSessions() async {
    emit(state.copyWith(status: UpcomingSessionsStatus.loading));

    final result = await _repository.getCounselingSchedules(
      status: ['SCHEDULED', 'ONGOING'],
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UpcomingSessionsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (sessions) => emit(
        state.copyWith(
          status: UpcomingSessionsStatus.success,
          upcomingSessions: sessions,
        ),
      ),
    );
  }

  String getLocalizedStatus(String status) {
    switch (status) {
      case 'SCHEDULED':
        return 'Terjadwal';
      case 'ONGOING':
        return 'Berlangsung';
      default:
        return status;
    }
  }

  bool canJoinSession(String status) {
    return status == 'ONGOING';
  }
}




