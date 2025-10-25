import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import '../widgets/create_journal_title_input.dart';
import '../widgets/create_journal_content_input.dart';

class CreateJournalPage extends StatefulWidget {
  const CreateJournalPage({super.key});

  @override
  State<CreateJournalPage> createState() => _CreateJournalPageState();
}

class _CreateJournalPageState extends State<CreateJournalPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;
  late JournalCubit _cubit;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cubit = get<JournalCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<JournalCubit, JournalState>(
        listener: (context, state) {
          if (state is JournalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            setState(() {
              _isLoading = false;
            });
          } else if (state is JournalCreated && _isLoading) {
            // Journal was created successfully
            setState(() {
              _isLoading = false;
            });
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jurnal berhasil ditambahkan'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate back to journal page and trigger refresh
            Navigator.of(context).pop(true); // Pass true to indicate success
          }
        },
        child: Scaffold(
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
                CreateJournalTitleInput(controller: _titleController),
                const SizedBox(height: 16),
                CreateJournalContentInput(controller: _contentController),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TemaniButton(
                        type: 3,
                        text: _isLoading ? 'Menyimpan...' : 'Simpan',
                        onPressed: _isLoading ? null : _saveJournal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveJournal() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan konten tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Use the cubit directly
    _cubit.createJournal(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );
  }
}
