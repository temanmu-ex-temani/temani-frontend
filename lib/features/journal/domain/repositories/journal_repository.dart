import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/journal/domain/entities/journal.dart';

abstract class JournalRepository {
  Future<Either<Failure, List<Journal>>> getAllJournals();
  Future<Either<Failure, Journal>> createJournal({
    required String title,
    required String content,
  });
  Future<Either<Failure, Journal>> updateJournal({
    required String id,
    required String title,
    required String content,
  });
  Future<Either<Failure, void>> deleteJournal(String id);
}
