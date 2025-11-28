import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temanmu/core/themes/_themes.dart';
import 'package:temanmu/features/journal/domain/entities/journal.dart';
import 'package:temanmu/features/journal/presentation/cubit/journal_cubit.dart';
import 'journal_card.dart';

class JournalList extends StatelessWidget {
  final Function(Journal)? onJournalTap;

  const JournalList({super.key, this.onJournalTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        if (state is JournalLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is JournalError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat jurnal',
                  style: FontTheme.textSemiBold.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: FontTheme.captionRegular.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<JournalCubit>().loadJournals();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (state is JournalLoaded) {
          if (state.journals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada jurnal',
                    style: FontTheme.textSemiBold.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai tulis jurnal pertama Anda',
                    style: FontTheme.captionRegular.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: state.journals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final journal = state.journals[index];
              return JournalCard(
                journal: journal,
                onTap: () => onJournalTap?.call(journal),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
