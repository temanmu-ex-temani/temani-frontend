import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:temani_frontend/core/bases/widgets/temani_button.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/todo/presentation/cubit/todo_cubit.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  bool _isShared = false;
  late final TodoCubit _todoCubit;

  @override
  void initState() {
    super.initState();
    _todoCubit = GetIt.instance<TodoCubit>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
        title: Text('Buat Kelompok ToDo', style: FontTheme.bodyBold),
      ),
      body: BlocProvider.value(
        value: _todoCubit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Nama kelompok', style: FontTheme.textSemiBold),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                cursorColor: BaseColors.info,
                decoration: InputDecoration(
                  hintText: 'Contoh: Aktivitas harian',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: BaseColors.info, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isShared,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Bagikan dengan pendamping',
                  style: FontTheme.textRegular,
                ),
                activeColor: BaseColors.info,
                onChanged: (value) {
                  setState(() {
                    _isShared = value;
                  });
                },
              ),
              const Spacer(),
              BlocBuilder<TodoCubit, TodoState>(
                builder: (context, state) {
                  final isLoading =
                      state.isActionInProgress &&
                      state.status != TodoStatus.loading;
                  return SizedBox(
                    width: double.infinity,
                    child: TemaniButton(
                      type: 3,
                      text: isLoading ? 'Menyimpan...' : 'Simpan',
                      onPressed: isLoading ? null : _onSave,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    _todoCubit.createTodoList(title: title, isShared: _isShared).then((_) {
      Navigator.of(context).pop();
    });
  }
}
