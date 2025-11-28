import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:temanmu/core/bases/widgets/temani_button.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/counseling/presentation/cubit/create_schedule_cubit.dart';
import 'package:temanmu/services/depedencies/di.dart';
import 'package:temanmu/services/router_service.dart';
import 'package:temanmu/services/toast_service.dart';

class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  State<CreateSchedulePage> createState() => _CreateSchedulePageState();
}

class _CreateSchedulePageState extends State<CreateSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDateTime;
  late final CreateScheduleCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = get<CreateScheduleCubit>();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _meetingLinkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Pilih Tanggal',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: BaseColors.info.shade600,
            onPrimary: Colors.white,
            onSurface: Colors.black,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      ),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: 'Pilih Waktu',
        cancelText: 'Batal',
        confirmText: 'Pilih',
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: BaseColors.info.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        ),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDateTime == null) {
      ToastService.show(context, 'Pilih tanggal dan waktu terlebih dahulu');
      return;
    }

    _cubit.createSchedule(
      scheduledAt: _selectedDateTime!,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      meetingLink: _meetingLinkController.text.trim(),
      notes: _notesController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<CreateScheduleCubit, CreateScheduleState>(
        listener: (context, state) {
          if (state is CreateScheduleSuccess) {
            ToastService.show(context, 'Jadwal berhasil dibuat');
            // Return true to indicate success, so the calling page can refresh
            router.pop(true);
          } else if (state is CreateScheduleError) {
            ToastService.show(context, state.message);
          }
        },
        child: Builder(
          builder: (context) => Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
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
              child: Column(
                children: [
                  // AppBar
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () => router.pop(),
                    ),
                    centerTitle: true,
                    title: Text('Buat Jadwal', style: FontTheme.bodyBold),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        label: 'Judul',
                        controller: _titleController,
                        hint: 'Masukkan judul sesi konseling',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Deskripsi',
                        controller: _descriptionController,
                        hint: 'Masukkan deskripsi sesi konseling',
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDateTimePicker(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Meeting Link (Opsional)',
                        controller: _meetingLinkController,
                        hint: 'Masukkan link meeting (contoh: Google Meet)',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Catatan (Opsional)',
                        controller: _notesController,
                        hint: 'Masukkan catatan tambahan',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<CreateScheduleCubit, CreateScheduleState>(
                        builder: (context, state) {
                          final isLoading = state is CreateScheduleLoading;
                          return SizedBox(
                            width: double.infinity,
                            child: TemaniButton(
                              type: 3,
                              text: isLoading ? 'Membuat...' : 'Buat Jadwal',
                              onPressed: isLoading ? null : _submitForm,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FontTheme.textSemiBold.copyWith(
            fontSize: 14,
            color: BaseColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: FontTheme.textRegular.copyWith(
              color: BaseColors.textTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: BaseColors.borderLight,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: BaseColors.borderLight,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: BaseColors.info.shade600,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: FontTheme.textRegular,
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal & Waktu',
          style: FontTheme.textSemiBold.copyWith(
            fontSize: 14,
            color: BaseColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDateTime,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: BaseColors.borderLight,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: BaseColors.info.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDateTime != null
                        ? DateFormat('EEEE, d MMMM yyyy, HH:mm', 'id_ID')
                            .format(_selectedDateTime!)
                        : 'Pilih tanggal dan waktu',
                    style: FontTheme.textRegular.copyWith(
                      color: _selectedDateTime != null
                          ? BaseColors.textPrimary
                          : BaseColors.textTertiary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: BaseColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_selectedDateTime == null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              'Tanggal dan waktu wajib diisi',
              style: FontTheme.captionRegular.copyWith(
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}

