import 'package:flutter/material.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_list.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Jurnal Harian', style: FontTheme.bodyBold),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const JournalHeader(),
            const SizedBox(height: 16),
            Text('Daftar jurnal', style: FontTheme.textSemiBold),
            const SizedBox(height: 8),
            const Expanded(child: JournalList()),
          ],
        ),
      ),
    );
  }
}
