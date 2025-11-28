import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class TodoTaskList extends StatefulWidget {
  const TodoTaskList({super.key});

  @override
  State<TodoTaskList> createState() => _TodoTaskListState();
}

class _TodoTaskListState extends State<TodoTaskList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Map<String, dynamic>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = [
      {'title': 'Sarapan pagi', 'time': '07:00 AM', 'done': false},
      {'title': 'Mandi pagi', 'time': '08:00 AM', 'done': false},
      {'title': 'Mandi pagi', 'time': '08:00 AM', 'done': true},
      {'title': 'Mandi pagi', 'time': '08:00 AM', 'done': true},
    ];
  }

  void _toggleDone(int index) {
    setState(() {
      final task = tasks.removeAt(index);
      task['done'] = !(task['done'] as bool);
      // Insert at new position (bottom if done, top if not done)
      if (task['done']) {
        tasks.add(task);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) =>
              _buildTaskItem(task, animation, index, removed: true),
          duration: const Duration(milliseconds: 300),
        );
        _listKey.currentState?.insertItem(
          tasks.length - 1,
          duration: const Duration(milliseconds: 300),
        );
      } else {
        tasks.insert(0, task);
        _listKey.currentState?.removeItem(
          index,
          (context, animation) =>
              _buildTaskItem(task, animation, index, removed: true),
          duration: const Duration(milliseconds: 300),
        );
        _listKey.currentState?.insertItem(
          0,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  Widget _buildTaskItem(
    Map<String, dynamic> task,
    Animation<double> animation,
    int index, {
    bool removed = false,
  }) {
    final bool done = task['done'] as bool;
    final String title = task['title'] as String;
    final String time = task['time'] as String;
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3EAF2), width: 2),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: removed ? null : () => _toggleDone(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: done ? const Color(0xFF4B9EFF) : Colors.transparent,
                  border: Border.all(
                    color:
                        done
                            ? const Color(0xFF4B9EFF)
                            : const Color(0xFFE3EAF2),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    done
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      title,
                      key: ValueKey(done),
                      style:
                          done
                              ? FontTheme.textRegular.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFFB0B0B0),
                              )
                              : FontTheme.textRegular,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      time,
                      key: ValueKey('time-$done'),
                      style:
                          done
                              ? FontTheme.captionRegular.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFFB0B0B0),
                              )
                              : FontTheme.captionRegular.copyWith(
                                color: const Color(0xFFB0B0B0),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Color(0xFFB0B0B0)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: tasks.length,
      itemBuilder: (context, index, animation) {
        return _buildTaskItem(tasks[index], animation, index);
      },
    );
  }
}
