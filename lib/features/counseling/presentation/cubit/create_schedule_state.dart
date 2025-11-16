part of 'create_schedule_cubit.dart';

abstract class CreateScheduleState extends Equatable {
  const CreateScheduleState();

  @override
  List<Object?> get props => [];
}

class CreateScheduleInitial extends CreateScheduleState {
  const CreateScheduleInitial();
}

class CreateScheduleLoading extends CreateScheduleState {
  const CreateScheduleLoading();
}

class CreateScheduleSuccess extends CreateScheduleState {
  const CreateScheduleSuccess();
}

class CreateScheduleError extends CreateScheduleState {
  final String message;

  const CreateScheduleError({required this.message});

  @override
  List<Object?> get props => [message];
}

