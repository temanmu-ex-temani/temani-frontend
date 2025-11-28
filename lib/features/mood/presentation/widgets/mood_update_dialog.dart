import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/mood/domain/entities/mood_log.dart';
import 'package:temanmu/features/mood/presentation/cubit/mood_cubit.dart';
import 'package:temanmu/features/mood/presentation/widgets/mood_button_real.dart';
import 'package:temanmu/services/toast_service.dart';

class MoodUpdateDialog extends StatefulWidget {
  final MoodLog currentMood;
  final MoodCubit moodCubit;

  const MoodUpdateDialog({
    super.key,
    required this.currentMood,
    required this.moodCubit,
  });

  @override
  State<MoodUpdateDialog> createState() => _MoodUpdateDialogState();
}

class _MoodUpdateDialogState extends State<MoodUpdateDialog> {
  int? selectedMood;

  @override
  void initState() {
    super.initState();
    selectedMood =
        widget.currentMood.emotionScale - 1; // Convert to 0-based index
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.moodCubit,
      child: BlocConsumer<MoodCubit, MoodState>(
        listener: (context, state) {
          if (state.status == MoodStatus.error) {
            ToastService.show(context, state.errorMessage);
          } else if (state.status == MoodStatus.success) {
            Navigator.of(context).pop();
            ToastService.show(context, 'Mood berhasil diperbarui');
          }
        },
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getMoodColor(
                            widget.currentMood.emotionScale,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _getMoodIcon(widget.currentMood.emotionScale),
                          color: _getMoodColor(widget.currentMood.emotionScale),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update Mood',
                              style: FontTheme.textSemiBold.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Mood saat ini: ${_getMoodText(widget.currentMood.emotionScale)}',
                              style: FontTheme.captionRegular.copyWith(
                                color: BaseColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: BaseColors.neutral.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: BaseColors.neutral.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mood Selection
                  Text(
                    'Pilih mood baru:',
                    style: FontTheme.textMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mood Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(5, (index) {
                        final moodScale = index + 1;
                        final isSelected = selectedMood == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: MoodButtonReal(
                            scale: moodScale,
                            selected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedMood = index;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: BaseColors.neutral.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BaseColors.borderLight),
                            ),
                            child: Center(
                              child: Text(
                                'Batal',
                                style: FontTheme.textMedium.copyWith(
                                  color: BaseColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              selectedMood != null &&
                                      selectedMood !=
                                          (widget.currentMood.emotionScale - 1)
                                  ? _updateMood
                                  : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  selectedMood != null &&
                                          selectedMood !=
                                              (widget.currentMood.emotionScale -
                                                  1)
                                      ? BaseColors.info
                                      : BaseColors.neutral.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child:
                                  state.status == MoodStatus.loading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        'Update',
                                        style: FontTheme.textMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateMood() {
    if (selectedMood == null) return;

    final newMoodScale = selectedMood! + 1;
    final newMoodVisual = widget.moodCubit.getMoodVisualFromScale(newMoodScale);

    widget.moodCubit.updateMoodLog(
      id: widget.currentMood.id,
      moodVisual: newMoodVisual,
      emotionScale: newMoodScale,
    );
  }

  Color _getMoodColor(int scale) {
    switch (scale) {
      case 1:
        return BaseColors.rose.shade400;
      case 2:
        return BaseColors.orange.shade400;
      case 3:
        return BaseColors.yellow.shade400;
      case 4:
        return BaseColors.green.shade400;
      case 5:
        return BaseColors.primary.shade400;
      default:
        return BaseColors.neutral.shade400;
    }
  }

  IconData _getMoodIcon(int scale) {
    switch (scale) {
      case 1:
        return Icons.sentiment_very_dissatisfied;
      case 2:
        return Icons.sentiment_dissatisfied;
      case 3:
        return Icons.sentiment_neutral;
      case 4:
        return Icons.sentiment_satisfied;
      case 5:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _getMoodText(int scale) {
    switch (scale) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Biasa Saja';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return 'Biasa Saja';
    }
  }
}
