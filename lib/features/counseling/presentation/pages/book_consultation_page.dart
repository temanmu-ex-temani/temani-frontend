import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temani_frontend/core/themes/_themes.dart';
import 'package:temani_frontend/features/counseling/presentation/cubit/book_consultation_cubit.dart';
import 'package:temani_frontend/features/counseling/presentation/cubit/book_consultation_state.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/book_consultation_header.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/date_range_filter.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/schedule_list.dart';
import 'package:temani_frontend/features/counseling/presentation/widgets/book_next_button.dart';
import 'package:temani_frontend/services/depedencies/di.dart';
import 'package:temani_frontend/services/router_service.dart';

class BookConsultationPage extends StatelessWidget {
  const BookConsultationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get cubit from dependency injection
    final cubit = get<BookConsultationCubit>();

    // Load schedules on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.loadAvailableSchedules();
    });

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0.00, 1.00),
              colors: [Color(0xFFEFF6FF), Color(0xFFECFEFF), Color(0xFFECFDF5)],
              stops: [0, 0.5, 1],
              transform: GradientRotation(169 * 3.14159 / 180),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Sticky App Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFEFF6FF).withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const BookConsultationHeader(),
                ),

                // Filter Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      BlocBuilder<BookConsultationCubit, BookConsultationState>(
                        builder: (context, state) {
                          if (state is BookConsultationLoaded) {
                            return DateRangeFilter(
                              startDate: state.startDateFilter,
                              endDate: state.endDateFilter,
                              onDateRangeChanged: (startDate, endDate) {
                                context
                                    .read<BookConsultationCubit>()
                                    .updateDateFilter(startDate, endDate);
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                ),

                // Schedule List
                Expanded(
                  child:
                      BlocBuilder<BookConsultationCubit, BookConsultationState>(
                        builder: (context, state) {
                          if (state is BookConsultationLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (state is BookConsultationError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      size: 64,
                                      color: BaseColors.error.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Terjadi Kesalahan',
                                      style: FontTheme.bodySemiBold.copyWith(
                                        color: BaseColors.neutral.shade900,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.message,
                                      style: FontTheme.bodyMedium.copyWith(
                                        color: BaseColors.neutral.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state is BookConsultationLoaded) {
                            return ScheduleList(
                              schedules: state.filteredSchedules,
                              selectedSchedule: state.selectedSchedule,
                              onScheduleSelected: (schedule) {
                                context
                                    .read<BookConsultationCubit>()
                                    .selectSchedule(schedule);
                              },
                              isLoading: false,
                              errorMessage: null,
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                ),
              ],
            ),
          ),
        ),

        // Sticky Bottom Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFEFF6FF).withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BlocBuilder<BookConsultationCubit, BookConsultationState>(
            builder: (context, state) {
              bool hasSelectedSchedule = false;
              dynamic selectedSchedule;

              if (state is BookConsultationLoaded) {
                hasSelectedSchedule = state.selectedSchedule != null;
                selectedSchedule = state.selectedSchedule;
              }

              return BookNextButton(
                enabled: hasSelectedSchedule,
                onPressed: () {
                  if (selectedSchedule != null) {
                    // Navigate to payment page with selected schedule
                    router.push('/payment', extra: selectedSchedule);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
