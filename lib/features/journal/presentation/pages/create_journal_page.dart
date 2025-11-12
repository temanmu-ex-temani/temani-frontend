import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import '../widgets/create_journal_title_input.dart';
import '../widgets/create_journal_content_input.dart';
import 'package:temani_frontend/services/toast_service.dart';

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
            ToastService.show(context, state.message);
            setState(() {
              _isLoading = false;
            });
          } else if (state is JournalCreated && _isLoading) {
            setState(() {
              _isLoading = false;
            });
            ToastService.show(context, 'Jurnal berhasil ditambahkan');
            Navigator.of(context).pop(true);
          }
        },
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
            title: Text('Tulis jurnal', style: FontTheme.bodyBold),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.black),
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
        ),
      ),
    );
  }

  void _saveJournal() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ToastService.show(context, 'Judul dan konten tidak boleh kosong');
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
