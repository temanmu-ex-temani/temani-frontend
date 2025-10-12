import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class CreateTodoDescriptionInput extends StatelessWidget {
  const CreateTodoDescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Deskripsi tugasmu', style: FontTheme.textSemiBold),
          const SizedBox(height: 8),
          TextField(
            minLines: 8,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Tulis deskripsi tugasmu di sini...',
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
        ],
      ),
    );
  }
}
