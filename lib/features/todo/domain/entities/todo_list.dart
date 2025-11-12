class TodoItem {
  final String id;
  final String toDoListId;
  final String description;
  final bool isComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  TodoItem({
    required this.id,
    required this.toDoListId,
    required this.description,
    required this.isComplete,
    required this.createdAt,
    required this.updatedAt,
  });
}

class TodoList {
  final String id;
  final String userId;
  final String title;
  final bool isShared;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TodoItem> items;

  TodoList({
    required this.id,
    required this.userId,
    required this.title,
    required this.isShared,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });
}

