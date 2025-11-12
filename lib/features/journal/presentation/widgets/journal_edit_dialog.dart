import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/journal/domain/entities/journal.dart';

class JournalEditDialog extends StatefulWidget {
  final Journal journal;
  final Function(String title, String content) onSave;

  const JournalEditDialog({
    super.key,
    required this.journal,
    required this.onSave,
  });

  @override
  State<JournalEditDialog> createState() => _JournalEditDialogState();
}

class _JournalEditDialogState extends State<JournalEditDialog> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal.title);
    _contentController = TextEditingController(text: widget.journal.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BaseColors.info.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: BaseColors.info.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit Jurnal',
                  style: FontTheme.subHeader.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title input
            Text('Judul', style: FontTheme.textSemiBold),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Masukkan judul jurnal',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE3EAF2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: BaseColors.info.shade600),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Content input
            Text('Konten', style: FontTheme.textSemiBold),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Tulis isi jurnal Anda...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE3EAF2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: BaseColors.info.shade600),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: FontTheme.textSemiBold.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty &&
                        _contentController.text.trim().isNotEmpty) {
                      widget.onSave(
                        _titleController.text.trim(),
                        _contentController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                backgroundColor: BaseColors.info.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Simpan',
                    style: FontTheme.textSemiBold.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
