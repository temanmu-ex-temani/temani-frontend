import 'package:either_dart/either.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/counseling/domain/entities/counseling_schedule.dart';

abstract class CounselingScheduleRepository {
  Future<Either<Failure, List<CounselingSchedule>>> getAvailableSchedules();
}
