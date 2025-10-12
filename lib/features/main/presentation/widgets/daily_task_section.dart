import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/services/router_service.dart';

class Task {
  String title;
  String time;
  bool completed;
  Task({required this.title, required this.time, this.completed = false});
}

class DailyTaskSection extends StatefulWidget {
  const DailyTaskSection({super.key});

  @override
  State<DailyTaskSection> createState() => _DailyTaskSectionState();
}

class _DailyTaskSectionState extends State<DailyTaskSection> {
  final List<Task> tasks = [
    Task(title: 'Sarapan pagi', time: '07:00 AM', completed: false),
    Task(title: 'Mandi pagi', time: '08:00 AM', completed: true),
    Task(title: 'Olahraga', time: '09:00 AM', completed: false),
    Task(title: 'Belajar', time: '10:00 AM', completed: false),
    Task(title: 'Membaca buku', time: '11:00 AM', completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tugasmu hari ini', style: FontTheme.textMedium),
              GestureDetector(
                onTap: () => router.push('/todo'),
                child: Text(
                  'Lihat lainnya',
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.info.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...List.generate(
            2,
            (i) => _TaskCard(
              task: tasks[i],
              onToggle: () {
                setState(() {
                  tasks[i].completed = !tasks[i].completed;
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              '+${tasks.length - 2} Lainnya',
              style: FontTheme.captionRegular.copyWith(
                color: BaseColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  const _TaskCard({required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BaseColors.borderLight),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child:
                task.completed
                    ? Icon(
                      Icons.check_circle,
                      color: BaseColors.success.shade400,
                      size: 20,
                    )
                    : Icon(
                      Icons.radio_button_unchecked,
                      color: BaseColors.borderMedium,
                      size: 20,
                    ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: FontTheme.textRegular.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                    color:
                        task.completed
                            ? BaseColors.textSecondary
                            : BaseColors.textPrimary,
                  ),
                ),
                Text(
                  task.time,
                  style: FontTheme.captionRegular.copyWith(
                    color: BaseColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
