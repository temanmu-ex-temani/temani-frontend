import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/core/client/_client.dart';
import 'package:temani_frontend/core/environments/_environments.dart';
import 'package:temani_frontend/core/errors/failure.dart';
import 'package:temani_frontend/features/todo/data/models/todo_list_model.dart';

abstract class TodoRemoteDataSource {
  Future<Either<Failure, TodoListArrayResponse>> getTodoLists();
  Future<Either<Failure, TodoListResponse>> createTodoList({
    required String title,
    required bool isShared,
  });
  Future<Either<Failure, TodoListResponse>> updateTodoList({
    required String id,
    required String title,
    required bool isShared,
  });
  Future<Either<Failure, void>> deleteTodoList(String id);
  Future<Either<Failure, TodoItemResponse>> createTodoItem({
    required String listId,
    required String description,
  });
  Future<Either<Failure, TodoItemResponse>> updateTodoItem({
    required String id,
    required String description,
  });
  Future<Either<Failure, TodoItemResponse>> toggleTodoItem(String id);
  Future<Either<Failure, void>> deleteTodoItem(String id);
}

@Injectable(as: TodoRemoteDataSource)
class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final Dio dio;

  TodoRemoteDataSourceImpl({required this.dio});

  @override
  Future<Either<Failure, TodoListArrayResponse>> getTodoLists() async {
    return await apiCall<TodoListArrayResponse>(
      getIt<Map<String, dynamic>>(
        EndPoints.todoLists,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoListArrayResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, TodoListResponse>> createTodoList({
    required String title,
    required bool isShared,
  }) async {
    final requestData =
        TodoListRequest(title: title, isShared: isShared).toJson();

    return await apiCall<TodoListResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.todoListsCreate,
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoListResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, TodoListResponse>> updateTodoList({
    required String id,
    required String title,
    required bool isShared,
  }) async {
    final requestData =
        TodoListRequest(title: title, isShared: isShared).toJson();

    return await apiCall<TodoListResponse>(
      putIt<Map<String, dynamic>>(
        EndPoints.todoListById(id),
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoListResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTodoList(String id) async {
    return await apiCall<void>(
      deleteIt<Map<String, dynamic>>(
        EndPoints.todoListById(id),
      ).then((_) => null),
    );
  }

  @override
  Future<Either<Failure, TodoItemResponse>> createTodoItem({
    required String listId,
    required String description,
  }) async {
    final requestData = TodoItemRequest(description: description).toJson();

    return await apiCall<TodoItemResponse>(
      postIt<Map<String, dynamic>>(
        EndPoints.todoItemsByList(listId),
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoItemResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, TodoItemResponse>> updateTodoItem({
    required String id,
    required String description,
  }) async {
    final requestData = TodoItemRequest(description: description).toJson();

    return await apiCall<TodoItemResponse>(
      putIt<Map<String, dynamic>>(
        EndPoints.todoItemById(id),
        model: requestData,
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoItemResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, TodoItemResponse>> toggleTodoItem(String id) async {
    return await apiCall<TodoItemResponse>(
      putIt<Map<String, dynamic>>(
        EndPoints.todoItemToggle(id),
      ).then((response) {
        final dynamic raw = response.data;
        final data = raw is String ? json.decode(raw) : raw;
        return TodoItemResponse.fromJson(data);
      }),
    );
  }

  @override
  Future<Either<Failure, void>> deleteTodoItem(String id) async {
    return await apiCall<void>(
      deleteIt<Map<String, dynamic>>(
        EndPoints.todoItemById(id),
      ).then((_) => null),
    );
  }
}

