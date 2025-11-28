import 'package:flutter/material.dart';
import 'package:temanmu/core/themes/_themes.dart';

class CreateJournalSaveButton extends StatelessWidget {
  const CreateJournalSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4B9EFF), Color(0xFF4BE7F2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.zero,
            textStyle: FontTheme.bodySemiBold.copyWith(color: Colors.white),
          ),
          child: const Text('Simpan'),
        ),
      ),
    );
  }
}
