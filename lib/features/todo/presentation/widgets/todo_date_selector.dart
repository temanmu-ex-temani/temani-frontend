import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:intl/intl.dart';

class TodoDateSelector extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  const TodoDateSelector({super.key, this.onDateSelected});

  @override
  State<TodoDateSelector> createState() => _TodoDateSelectorState();
}

class _TodoDateSelectorState extends State<TodoDateSelector> {
  late List<DateTime> dates;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    dates = List.generate(4, (i) => now.add(Duration(days: i)));
    selectedDate = dates[0];
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateSelected?.call(date);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF4B9EFF),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      _selectDate(picked);
      // If picked date is not in the visible list, update the list
      if (!dates.any((d) => _isSameDay(d, picked))) {
        setState(() {
          dates = List.generate(4, (i) => picked.add(Duration(days: i)));
        });
      }
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...dates.map((date) {
          final bool isSelected = _isSameDay(date, selectedDate);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _selectDate(date),
              child: Container(
                width: 56,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFE6F0FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? const Color(0xFF4B9EFF)
                            : const Color(0xFFE3EAF2),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('d').format(date),
                      style: FontTheme.textBold.copyWith(
                        color:
                            isSelected ? const Color(0xFF4B9EFF) : Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(date),
                      style: FontTheme.captionRegular.copyWith(
                        color:
                            isSelected ? const Color(0xFF4B9EFF) : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          );
        }),
        Spacer(),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF6FAFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE3EAF2), width: 2),
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Color(0xFFB0B0B0),
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
