import 'package:either_dart/either.dart';
import 'package:temanmu/core/errors/failure.dart';
import 'package:temanmu/features/todo/domain/entities/todo_list.dart';

abstract class TodoRepository {
  Future<Either<Failure, List<TodoList>>> getTodoLists();
  Future<Either<Failure, TodoList>> createTodoList({
    required String title,
    required bool isShared,
  });
  Future<Either<Failure, TodoList>> updateTodoList({
    required String id,
    required String title,
    required bool isShared,
  });
  Future<Either<Failure, void>> deleteTodoList(String id);
  Future<Either<Failure, TodoItem>> createTodoItem({
    required String listId,
    required String description,
  });
  Future<Either<Failure, TodoItem>> updateTodoItem({
    required String id,
    required String description,
  });
  Future<Either<Failure, TodoItem>> toggleTodoItem(String id);
  Future<Either<Failure, void>> deleteTodoItem(String id);
}

