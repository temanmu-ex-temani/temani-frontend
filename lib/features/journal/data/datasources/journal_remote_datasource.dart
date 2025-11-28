import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/client/_client.dart';
import 'package:temanmu/core/environments/_environments.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/journal/data/models/journal_model.dart';

abstract class JournalRemoteDataSource {
  Future<Either<Failure, JournalListResponse>> getAllJournals();
  Future<Either<Failure, JournalResponse>> createJournal({
    required String title,
    required String content,
  });
  Future<Either<Failure, JournalResponse>> updateJournal({
    required String id,
    required String title,
    required String content,
  });
  Future<Either<Failure, JournalResponse>> deleteJournal(String id);
}

@Injectable(as: JournalRemoteDataSource)
class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  final Dio dio;

  JournalRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, JournalListResponse>> getAllJournals() async {
    return await apiCall<JournalListResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.journals,
      ).then((response) => JournalListResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, JournalResponse>> createJournal({
    required String title,
    required String content,
  }) async {
    final requestData = JournalRequest(title: title, content: content).toJson();

    return await apiCall<JournalResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.journals,
        model: requestData,
      ).then((response) => JournalResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, JournalResponse>> updateJournal({
    required String id,
    required String title,
    required String content,
  }) async {
    final requestData = JournalRequest(title: title, content: content).toJson();

    return await apiCall<JournalResponse>(
      putIt<Map<String, dynamic>>(
        '${EndPoints.journals}/$id',
        model: requestData,
      ).then((response) => JournalResponse.fromJson(response.data!)),
    );
  }

  @override
  Future<Either<Failure, JournalResponse>> deleteJournal(String id) async {
    return await apiCall<JournalResponse>(
      deleteIt<Map<String, dynamic>>(
        '${EndPoints.journals}/$id',
      ).then((response) => JournalResponse.fromJson(response.data!)),
    );
  }
}
