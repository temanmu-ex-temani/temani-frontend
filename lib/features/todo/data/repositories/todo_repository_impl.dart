import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/todo/data/datasources/todo_remote_datasource.dart';
import 'package:temanmu/features/todo/domain/entities/todo_list.dart';
import 'package:temanmu/features/todo/domain/repositories/todo_repository.dart';

@Injectable(as: TodoRepository)
class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;

  TodoRepositoryImpl({required TodoRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<TodoList>>> getTodoLists() async {
    final result = await _remoteDataSource.getTodoLists();
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data),
    );
  }

  @override
  Future<Either<Failure, TodoList>> createTodoList({
    required String title,
    required bool isShared,
  }) async {
    final result = await _remoteDataSource.createTodoList(
      title: title,
      isShared: isShared,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, TodoList>> updateTodoList({
    required String id,
    required String title,
    required bool isShared,
  }) async {
    final result = await _remoteDataSource.updateTodoList(
      id: id,
      title: title,
      isShared: isShared,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTodoList(String id) async {
    return await _remoteDataSource.deleteTodoList(id);
  }

  @override
  Future<Either<Failure, TodoItem>> createTodoItem({
    required String listId,
    required String description,
  }) async {
    final result = await _remoteDataSource.createTodoItem(
      listId: listId,
      description: description,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, TodoItem>> updateTodoItem({
    required String id,
    required String description,
  }) async {
    final result = await _remoteDataSource.updateTodoItem(
      id: id,
      description: description,
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, TodoItem>> toggleTodoItem(String id) async {
    final result = await _remoteDataSource.toggleTodoItem(id);
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response.data!),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTodoItem(String id) async {
    return await _remoteDataSource.deleteTodoItem(id);
  }
}

