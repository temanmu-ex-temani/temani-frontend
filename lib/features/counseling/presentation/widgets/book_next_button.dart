import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class BookNextButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;
  const BookNextButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration:
            enabled
                ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF51A2FF), Color(0xFF00D3F3)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                )
                : BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: FontTheme.bodySemiBold.copyWith(color: Colors.white),
          ),
          child: const Text(
            'Selanjutnya',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
