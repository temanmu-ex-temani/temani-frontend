import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/features/todo/domain/entities/todo_list.dart';
import 'package:temani_frontend/features/todo/domain/repositories/todo_repository.dart';

part 'todo_state.dart';

@injectable
class TodoCubit extends Cubit<TodoState> {
  final TodoRepository _repository;

  TodoCubit({required TodoRepository repository})
      : _repository = repository,
        super(const TodoState());

  Future<void> loadTodoLists() async {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
        errorMessage: null,
        isActionInProgress: false,
      ),
    );

    final result = await _repository.getTodoLists();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TodoStatus.error,
          errorMessage: failure.message,
          isActionInProgress: false,
        ),
      ),
      (lists) => emit(
        state.copyWith(
          status: TodoStatus.success,
          lists: lists,
          isActionInProgress: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> createTodoList({
    required String title,
    required bool isShared,
  }) async {
    emit(
      state.copyWith(
        isActionInProgress: true,
        errorMessage: null,
      ),
    );

    final result = await _repository.createTodoList(
      title: title,
      isShared: isShared,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> updateTodoList({
    required String id,
    required String title,
    required bool isShared,
  }) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.updateTodoList(
      id: id,
      title: title,
      isShared: isShared,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> deleteTodoList(String id) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.deleteTodoList(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> createTodoItem({
    required String listId,
    required String description,
  }) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.createTodoItem(
      listId: listId,
      description: description,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> updateTodoItem({
    required String id,
    required String description,
  }) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.updateTodoItem(
      id: id,
      description: description,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> toggleTodoItem(String id) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.toggleTodoItem(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> deleteTodoItem(String id) async {
    emit(state.copyWith(isActionInProgress: true, errorMessage: null));

    final result = await _repository.deleteTodoItem(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (_) => _refreshListsAfterAction(),
    );
  }

  Future<void> _refreshListsAfterAction() async {
    final result = await _repository.getTodoLists();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TodoStatus.error,
          isActionInProgress: false,
          errorMessage: failure.message,
        ),
      ),
      (lists) => emit(
        state.copyWith(
          status: TodoStatus.success,
          lists: lists,
          isActionInProgress: false,
          errorMessage: null,
        ),
      ),
    );
  }
}

