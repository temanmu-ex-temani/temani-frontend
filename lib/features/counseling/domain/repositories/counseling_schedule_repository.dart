import 'package:either_dart/either.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';

abstract class CounselingScheduleRepository {
  Future<Either<Failure, List<CounselingSchedule>>> getAvailableSchedules();
  Future<Either<Failure, List<CounselingSchedule>>> getCounselingSchedules({
    List<String>? status,
  });
  Future<Either<Failure, List<CounselingSchedule>>> getPeerCounselingSchedules();
  Future<Either<Failure, CounselingSchedule>> createSchedule({
    required DateTime scheduledAt,
    required String title,
    required String description,
    required String meetingLink,
    required String notes,
  });
  Future<Either<Failure, CounselingSchedule>> updateScheduleStatus({
    required String scheduleId,
    required String status,
  });
}
