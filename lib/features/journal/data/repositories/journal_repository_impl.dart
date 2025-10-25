import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/journal/data/datasources/journal_remote_datasource.dart';
import 'package:temani_frontend/features/journal/data/models/journal_model.dart';
import 'package:temani_frontend/features/journal/domain/entities/journal.dart';
import 'package:temani_frontend/features/journal/domain/repositories/journal_repository.dart';

@Injectable(as: JournalRepository)
class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource remoteDataSource;

  JournalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Journal>>> getAllJournals() async {
    final result = await remoteDataSource.getAllJournals();

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        response.data.map((model) => _mapModelToEntity(model)).toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, Journal>> createJournal({
    required String title,
    required String content,
  }) async {
    final result = await remoteDataSource.createJournal(
      title: title,
      content: content,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(_mapModelToEntity(response.data!)),
    );
  }

  @override
  Future<Either<Failure, Journal>> updateJournal({
    required String id,
    required String title,
    required String content,
  }) async {
    final result = await remoteDataSource.updateJournal(
      id: id,
      title: title,
      content: content,
    );

    return result.fold(
      (failure) => Left(failure),
      (response) => Right(_mapModelToEntity(response.data!)),
    );
  }

  @override
  Future<Either<Failure, void>> deleteJournal(String id) async {
    final result = await remoteDataSource.deleteJournal(id);

    return result.fold(
      (failure) => Left(failure),
      (response) => const Right(null),
    );
  }

  Journal _mapModelToEntity(JournalModel model) {
    return Journal(
      id: model.id,
      userId: model.userId,
      title: model.title,
      content: model.content,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
