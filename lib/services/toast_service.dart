import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';

class ToastService {
  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  static void show(BuildContext context, String message) {
    _timer?.cancel();
    _currentEntry?.remove();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40,
        left: 20,
        right: 20,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: BaseColors.info.shade700.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: FontTheme.textSemiBold.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    _currentEntry = entry;

    _timer = Timer(const Duration(seconds: 2), () {
      if (_currentEntry == entry) {
        entry.remove();
        _currentEntry = null;
      }
    });
  }
}

