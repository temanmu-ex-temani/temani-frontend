part of 'todo_cubit.dart';

enum TodoStatus { initial, loading, success, error }

class TodoState extends Equatable {
  final TodoStatus status;
  final List<TodoList> lists;
  final bool isActionInProgress;
  final String? errorMessage;

  const TodoState({
    this.status = TodoStatus.initial,
    this.lists = const [],
    this.isActionInProgress = false,
    this.errorMessage,
  });

  TodoState copyWith({
    TodoStatus? status,
    List<TodoList>? lists,
    bool? isActionInProgress,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      lists: lists ?? this.lists,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, lists, isActionInProgress, errorMessage];
}

