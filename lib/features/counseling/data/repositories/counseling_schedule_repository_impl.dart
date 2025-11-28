import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/counseling/data/datasources/counseling_schedule_remote_datasource.dart';
import 'package:temanmu/features/counseling/data/models/counseling_schedule_model.dart';
import 'package:temanmu/features/counseling/domain/entities/counseling_schedule.dart';
import 'package:temanmu/features/counseling/domain/repositories/counseling_schedule_repository.dart';

@Injectable(as: CounselingScheduleRepository)
class CounselingScheduleRepositoryImpl implements CounselingScheduleRepository {
  final CounselingScheduleRemoteDataSource remoteDataSource;

  CounselingScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CounselingSchedule>>>
  getAvailableSchedules() async {
    final result = await remoteDataSource.getAvailableSchedules();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        response.data.map((model) => _mapModelToEntity(model)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<CounselingSchedule>>> getCounselingSchedules({
    List<String>? status,
  }) async {
    final result = await remoteDataSource.getCounselingSchedules(
      status: status,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        response.data.map((model) => _mapModelToEntity(model)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<CounselingSchedule>>> getPeerCounselingSchedules() async {
    final result = await remoteDataSource.getPeerCounselingSchedules();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        response.data.map((model) => _mapModelToEntity(model)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, CounselingSchedule>> createSchedule({
    required DateTime scheduledAt,
    required String title,
    required String description,
    required String meetingLink,
    required String notes,
  }) async {
    final result = await remoteDataSource.createSchedule(
      scheduledAt: scheduledAt,
      title: title,
      description: description,
      meetingLink: meetingLink,
      notes: notes,
    );

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(_mapModelToEntity(model)),
    );
  }

  @override
  Future<Either<Failure, CounselingSchedule>> updateScheduleStatus({
    required String scheduleId,
    required String status,
  }) async {
    final result = await remoteDataSource.updateScheduleStatus(
      scheduleId: scheduleId,
      status: status,
    );

    return result.fold(
      (failure) => Left(failure),
      (model) => Right(_mapModelToEntity(model)),
    );
  }

  CounselingSchedule _mapModelToEntity(CounselingScheduleModel model) {
    return CounselingSchedule(
      id: model.id,
      clientId: model.clientId,
      clientName: model.clientName,
      counselorId: model.counselorId,
      counselorName: model.counselorName,
      counselorUsername: model.counselorUsername,
      scheduledAt: model.scheduledAt,
      title: model.title,
      description: model.description,
      meetingLink: model.meetingLink,
      notes: model.notes,
      status: model.status,
    );
  }
}
