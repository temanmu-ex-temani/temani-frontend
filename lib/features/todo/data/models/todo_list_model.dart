import 'package:temanmu/features/todo/domain/entities/todo_list.dart';

class TodoItemModel extends TodoItem {
  TodoItemModel({
    required super.id,
    required super.toDoListId,
    required super.description,
    required super.isComplete,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TodoItemModel.fromJson(Map<String, dynamic> json) {
    return TodoItemModel(
      id: json['id'] as String? ?? '',
      toDoListId: json['toDoListId'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isComplete: json['isComplete'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toDoListId': toDoListId,
      'description': description,
      'isComplete': isComplete,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class TodoListModel extends TodoList {
  TodoListModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.isShared,
    required super.createdAt,
    required super.updatedAt,
    required List<TodoItem> items,
  }) : super(items: items);

  factory TodoListModel.fromJson(Map<String, dynamic> json) {
    return TodoListModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      isShared: json['isShared'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map(
                (item) =>
                    TodoItemModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'isShared': isShared,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'items': items.map((item) {
        if (item is TodoItemModel) {
          return item.toJson();
        }
        return {
          'id': item.id,
          'toDoListId': item.toDoListId,
          'description': item.description,
          'isComplete': item.isComplete,
          'createdAt': item.createdAt.toIso8601String(),
          'updatedAt': item.updatedAt.toIso8601String(),
        };
      }).toList(),
    };
  }
}

class TodoListResponse {
  final int status;
  final String message;
  final TodoListModel? data;
  final String timestamp;

  TodoListResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TodoListModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class TodoListArrayResponse {
  final int status;
  final String message;
  final List<TodoListModel> data;
  final String timestamp;

  TodoListArrayResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory TodoListArrayResponse.fromJson(Map<String, dynamic> json) {
    return TodoListArrayResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    TodoListModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class TodoItemResponse {
  final int status;
  final String message;
  final TodoItemModel? data;
  final String timestamp;

  TodoItemResponse({
    required this.status,
    required this.message,
    this.data,
    required this.timestamp,
  });

  factory TodoItemResponse.fromJson(Map<String, dynamic> json) {
    return TodoItemResponse(
      status: json['status'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? TodoItemModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }
}

class TodoListRequest {
  final String title;
  final bool isShared;

  TodoListRequest({required this.title, required this.isShared});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isShared': isShared,
    };
  }
}

class TodoItemRequest {
  final String description;

  TodoItemRequest({required this.description});

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}

