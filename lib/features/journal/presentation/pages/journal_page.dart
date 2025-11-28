import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/journal/domain/entities/journal.dart';
import 'package:temanmu/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'create_journal_page.dart';
import 'journal_detail_page.dart';
import '../widgets/journal_header.dart';
import '../widgets/journal_list.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late JournalCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = get<JournalCubit>();
    _cubit.loadJournals();
  }

  Future<void> _navigateToCreateJournal() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CreateJournalPage()));

    // If the result is true, it means a journal was created successfully
    if (result == true) {
      _cubit.loadJournals(); // Refresh the journal list
    }
  }

  Future<void> _navigateToJournalDetail(Journal journal) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JournalDetailPage(journal: journal),
      ),
    );

    // If the result is true, it means a journal was updated or deleted
    if (result == true) {
      _cubit.loadJournals(); // Refresh the journal list
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.transparent,
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: const Alignment(0.00, -1.00),
              end: const Alignment(0.00, 1.00),
              colors: [
                BaseColors.info.shade50,
                BaseColors.cyan.shade50,
                BaseColors.success.shade50,
              ],
              stops: const [0, 0.5, 1],
              transform: GradientRotation(169 * 3.14159 / 180),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  JournalHeader(onCreateJournal: _navigateToCreateJournal),
                  const SizedBox(height: 16),
                  Text('Daftar jurnal', style: FontTheme.textSemiBold),
                  const SizedBox(height: 8),
                  Expanded(
                    child: JournalList(onJournalTap: _navigateToJournalDetail),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
