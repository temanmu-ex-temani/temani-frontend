import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:intl/intl.dart';

class CreateTodoDateTimePicker extends StatefulWidget {
  const CreateTodoDateTimePicker({super.key});

  @override
  State<CreateTodoDateTimePicker> createState() =>
      _CreateTodoDateTimePickerState();
}

class _CreateTodoDateTimePickerState extends State<CreateTodoDateTimePicker> {
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
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
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? now),
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
      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = 'Pilih tanggal & waktu';
    if (selectedDateTime != null) {
      displayText = DateFormat(
        'd MMMM yyyy, HH:mm',
        'id_ID',
      ).format(selectedDateTime!);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Waktu dan tanggal', style: FontTheme.textSemiBold),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickDateTime,
            child: AbsorbPointer(
              child: TextField(
                readOnly: true,
                controller: TextEditingController(text: displayText),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      PhosphorIcons.calendarBlank(),
                      color: BaseColors.secondary.shade500,
                    ),
                    onPressed: _pickDateTime,
                  ),
                  hintText: 'Pilih tanggal & waktu',
                  hintStyle: FontTheme.textRegular.copyWith(
                    color: const Color(0xFFB0B0B0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3EAF2),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3EAF2),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF4B9EFF),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: FontTheme.textRegular,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
