import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/todo/domain/entities/todo_list.dart';
import 'package:temani_frontend/features/todo/presentation/cubit/todo_cubit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late final TodoCubit _todoCubit;

  @override
  void initState() {
    super.initState();
    _todoCubit = GetIt.instance<TodoCubit>();
    _todoCubit.loadTodoLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Kelompok ToDo', style: FontTheme.bodyBold),
      ),
      body: BlocProvider.value(
        value: _todoCubit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TemaniButton(
                  type: 3,
                  text: 'Buat Kelompok',
                  onPressed: () => _showCreateListSheet(context),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<TodoCubit, TodoState>(
                  builder: (context, state) {
                    if (state.status == TodoStatus.loading &&
                        state.lists.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == TodoStatus.error &&
                        state.lists.isEmpty) {
                      return _ErrorState(
                        message: state.errorMessage ?? 'Gagal memuat ToDo.',
                        onRetry: _todoCubit.loadTodoLists,
                      );
                    }

                    if (state.lists.isEmpty) {
                      return _EmptyState(
                        onCreate: () {
                          _showCreateListSheet(context);
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => _todoCubit.loadTodoLists(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: state.lists.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final list = state.lists[index];
                          return _TodoListCard(
                            list: list,
                            onAddItem: () => _showAddItemSheet(context, list),
                            onToggleItem:
                                (item) => _todoCubit.toggleTodoItem(item.id),
                            onDeleteItem:
                                (item) => _todoCubit.deleteTodoItem(item.id),
                            onEditItem:
                                (item) =>
                                    _showEditItemSheet(context, list, item),
                            onEditList: () => _showEditListSheet(context, list),
                            onDeleteList:
                                () => _confirmDeleteList(context, list),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateListSheet(BuildContext context) {
    final titleController = TextEditingController();
    bool isShared = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buat Kelompok Baru', style: FontTheme.bodyBold),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    cursorColor: BaseColors.info,
                    decoration: InputDecoration(
                      labelText: 'Nama kelompok',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: BaseColors.info,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: isShared,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Bagikan dengan pendamping',
                      style: FontTheme.textRegular,
                    ),
                    activeColor: BaseColors.info,
                    onChanged: (value) {
                      setModalState(() {
                        isShared = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TemaniButton(
                    type: 3,
                    text: 'Simpan',
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      Navigator.of(context).pop();
                      _todoCubit.createTodoList(
                        title: title,
                        isShared: isShared,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showEditListSheet(BuildContext context, TodoList list) {
    final titleController = TextEditingController(text: list.title);
    bool isShared = list.isShared;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Kelompok', style: FontTheme.bodyBold),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    cursorColor: BaseColors.info,
                    decoration: InputDecoration(
                      labelText: 'Nama kelompok',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: BaseColors.info,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    value: isShared,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Bagikan dengan pendamping',
                      style: FontTheme.textRegular,
                    ),
                    activeColor: BaseColors.info,
                    onChanged: (value) {
                      setModalState(() {
                        isShared = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TemaniButton(
                    type: 3,
                    text: 'Perbarui',
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) return;
                      Navigator.of(context).pop();
                      _todoCubit.updateTodoList(
                        id: list.id,
                        title: title,
                        isShared: isShared,
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showAddItemSheet(BuildContext context, TodoList list) {
    final descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tambah Item', style: FontTheme.bodyBold),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                cursorColor: BaseColors.info,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: BaseColors.info, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TemaniButton(
                type: 3,
                text: 'Tambahkan',
                onPressed: () {
                  final description = descriptionController.text.trim();
                  if (description.isEmpty) return;
                  Navigator.of(context).pop();
                  _todoCubit.createTodoItem(
                    listId: list.id,
                    description: description,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditItemSheet(BuildContext context, TodoList list, TodoItem item) {
    final descriptionController = TextEditingController(text: item.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Item', style: FontTheme.bodyBold),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                cursorColor: BaseColors.info,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: BaseColors.info, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TemaniButton(
                type: 3,
                text: 'Perbarui',
                onPressed: () {
                  final description = descriptionController.text.trim();
                  if (description.isEmpty) return;
                  Navigator.of(context).pop();
                  _todoCubit.updateTodoItem(
                    id: item.id,
                    description: description,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteList(BuildContext context, TodoList list) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus kelompok'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus kelompok ini beserta semua itemnya?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _todoCubit.deleteTodoList(list.id);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}

class _TodoListCard extends StatelessWidget {
  final TodoList list;
  final VoidCallback onAddItem;
  final void Function(TodoItem item) onToggleItem;
  final void Function(TodoItem item) onDeleteItem;
  final void Function(TodoItem item) onEditItem;
  final VoidCallback onEditList;
  final VoidCallback onDeleteList;

  const _TodoListCard({
    required this.list,
    required this.onAddItem,
    required this.onToggleItem,
    required this.onDeleteItem,
    required this.onEditItem,
    required this.onEditList,
    required this.onDeleteList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BaseColors.borderLight, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.title, style: FontTheme.bodyBold),
                    if (list.isShared)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: BaseColors.info.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Dibagikan',
                            style: FontTheme.captionSemiBold.copyWith(
                              color: BaseColors.info.shade700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF64748B)),
                    onPressed: onEditList,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFFEF4444),
                    ),
                    onPressed: onDeleteList,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (list.items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Belum ada item. Tambahkan item untuk daftar ini.',
                style: FontTheme.textRegular.copyWith(
                  color: BaseColors.textSecondary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = list.items[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color:
                          item.isComplete
                              ? BaseColors.success.shade200
                              : BaseColors.borderLight,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => onToggleItem(item),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                item.isComplete
                                    ? BaseColors.success
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  item.isComplete
                                      ? BaseColors.success
                                      : BaseColors.borderLight,
                              width: 2,
                            ),
                          ),
                          child:
                              item.isComplete
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18,
                                  )
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.description,
                              style: FontTheme.textRegular.copyWith(
                                decoration:
                                    item.isComplete
                                        ? TextDecoration.lineThrough
                                        : null,
                                color:
                                    item.isComplete
                                        ? BaseColors.textSecondary
                                        : BaseColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Diperbarui ${_formatDate(item.updatedAt)}',
                              style: FontTheme.captionRegular.copyWith(
                                color: BaseColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF64748B)),
                        onPressed: () => onEditItem(item),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFEF4444),
                        ),
                        onPressed: () => onDeleteItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 12),
          TemaniButton(type: 3, text: 'Tambah Item', onPressed: onAddItem),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.clipboardText(),
            size: 48,
            color: BaseColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text('Belum ada kelompok ToDo', style: FontTheme.textSemiBold),
          const SizedBox(height: 4),
          Text(
            'Buat kelompok untuk mulai mengatur tugasmu.',
            style: FontTheme.textRegular.copyWith(
              color: BaseColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          TemaniButton(type: 3, text: 'Buat Kelompok', onPressed: onCreate),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.warningCircle(),
            size: 48,
            color: BaseColors.error,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: FontTheme.textRegular.copyWith(
              color: BaseColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TemaniButton(type: 3, text: 'Coba Lagi', onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}
