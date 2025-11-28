import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/todo/domain/entities/todo_list.dart';
import 'package:temanmu/features/todo/presentation/cubit/todo_cubit.dart';
import 'package:temanmu/services/router_service.dart';

class HomeTodoSection extends StatelessWidget {
  const HomeTodoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final lists = state.lists;
        final isLoading =
            state.status == TodoStatus.loading && lists.isEmpty;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BaseColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kelompok ToDo', style: FontTheme.textMedium),
                  GestureDetector(
                    onTap: () => router.push('/todo'),
                    child: Text(
                      'Lainnya',
                      style: FontTheme.captionRegular.copyWith(
                        color: BaseColors.info.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isLoading)
                const _TodoLoadingPlaceholder()
              else if (lists.isEmpty)
                _TodoEmptySection(onGoToTodo: () => router.push('/todo'))
              else
                Column(
                  children: [
                    _TodoListPreview(list: lists.first),
                    if (lists.length > 1) ...[
                      const SizedBox(height: 12),
                      _TodoListPreview(list: lists[1]),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TodoLoadingPlaceholder extends StatelessWidget {
  const _TodoLoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        2,
        (index) => Container(
          margin: EdgeInsets.only(bottom: index == 1 ? 0 : 12),
          height: 52,
          decoration: BoxDecoration(
            color: BaseColors.neutral.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _TodoEmptySection extends StatelessWidget {
  final VoidCallback onGoToTodo;

  const _TodoEmptySection({required this.onGoToTodo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: BaseColors.info.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.clipboardText(),
            color: BaseColors.info.shade500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum ada kelompok',
                  style: FontTheme.textSemiBold,
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai buat kelompok ToDo untuk mengatur aktivitasmu.',
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onGoToTodo,
            child: Text(
              'Buat',
              style: FontTheme.textSemiBold.copyWith(
                color: BaseColors.info.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoListPreview extends StatelessWidget {
  final TodoList list;

  const _TodoListPreview({required this.list});

  @override
  Widget build(BuildContext context) {
    final items = list.items;
    final shownItems = items.take(3).toList();
    final remaining = items.length - shownItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.folderOpen(),
              color: BaseColors.info.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                list.title,
                style: FontTheme.textMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (list.isShared)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: BaseColors.info.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Dibagikan',
                  style: FontTheme.captionSemiBold.copyWith(
                    color: BaseColors.info.shade600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (shownItems.isEmpty)
          Text(
            'Belum ada item di kelompok ini.',
            style: FontTheme.textRegular.copyWith(
              color: BaseColors.textSecondary,
            ),
          )
        else
          ...shownItems.map(
            (item) => InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () =>
                  context.read<TodoCubit>().toggleTodoItem(item.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: BaseColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: item.isComplete
                        ? BaseColors.success.shade200
                        : BaseColors.borderLight,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      item.isComplete
                          ? PhosphorIcons.checkCircle()
                          : PhosphorIcons.circle(),
                      color: item.isComplete
                          ? BaseColors.success
                          : BaseColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.description,
                        style: FontTheme.textRegular.copyWith(
                          decoration: item.isComplete
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isComplete
                              ? BaseColors.textSecondary
                              : BaseColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (remaining > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '+$remaining item lainnya',
              style: FontTheme.captionRegular.copyWith(
                color: BaseColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

