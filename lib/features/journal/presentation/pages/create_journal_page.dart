import 'package:flutter/material.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/services/router_service.dart';
import '../widgets/create_journal_title_input.dart';
import '../widgets/create_journal_content_input.dart';
import '../widgets/create_journal_save_button.dart';

class CreateJournalPage extends StatelessWidget {
  const CreateJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text('Tulis jurnal', style: FontTheme.bodyBold),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const CreateJournalTitleInput(),
            const SizedBox(height: 16),
            const CreateJournalContentInput(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TemaniButton(
                    type: 3,
                    text: 'Simpan',
                    onPressed: () => router.go('/main'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
