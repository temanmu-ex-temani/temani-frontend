import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/features/counseling/domain/repositories/counseling_schedule_repository.dart';

part 'create_schedule_state.dart';

@injectable
class CreateScheduleCubit extends Cubit<CreateScheduleState> {
  final CounselingScheduleRepository _repository;

  CreateScheduleCubit({required CounselingScheduleRepository repository})
      : _repository = repository,
        super(const CreateScheduleInitial());

  Future<void> createSchedule({
    required DateTime scheduledAt,
    required String title,
    required String description,
    required String meetingLink,
    required String notes,
  }) async {
    emit(const CreateScheduleLoading());

    final result = await _repository.createSchedule(
      scheduledAt: scheduledAt,
      title: title,
      description: description,
      meetingLink: meetingLink,
      notes: notes,
    );

    result.fold(
      (failure) => emit(
        CreateScheduleError(
          message: failure.message.isNotEmpty
              ? failure.message
              : 'Gagal membuat jadwal',
        ),
      ),
      (_) => emit(const CreateScheduleSuccess()),
    );
  }

  void reset() {
    emit(const CreateScheduleInitial());
  }
}

