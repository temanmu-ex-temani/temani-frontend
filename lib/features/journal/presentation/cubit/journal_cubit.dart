import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/features/journal/domain/entities/journal.dart';
import 'package:temanmu/features/journal/domain/repositories/journal_repository.dart';

@injectable
class JournalCubit extends Cubit<JournalState> {
  final JournalRepository repository;

  JournalCubit({required this.repository}) : super(JournalInitial());

  Future<void> loadJournals() async {
    emit(JournalLoading());

    final result = await repository.getAllJournals();

    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (journals) => emit(JournalLoaded(journals)),
    );
  }

  Future<void> createJournal({
    required String title,
    required String content,
  }) async {
    final result = await repository.createJournal(
      title: title,
      content: content,
    );

    result.fold((failure) => emit(JournalError(failure.message)), (journal) {
      emit(JournalCreated(journal));
    });
  }

  Future<void> updateJournal({
    required String id,
    required String title,
    required String content,
  }) async {
    final result = await repository.updateJournal(
      id: id,
      title: title,
      content: content,
    );

    result.fold((failure) => emit(JournalError(failure.message)), (
      updatedJournal,
    ) {
      emit(JournalUpdated(updatedJournal));
    });
  }

  Future<void> deleteJournal(String id) async {
    final result = await repository.deleteJournal(id);

    result.fold((failure) => emit(JournalError(failure.message)), (_) {
      emit(JournalDeleted(id));
    });
  }
}

abstract class JournalState {}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoaded extends JournalState {
  final List<Journal> journals;

  JournalLoaded(this.journals);
}

class JournalError extends JournalState {
  final String message;

  JournalError(this.message);
}

class JournalCreated extends JournalState {
  final Journal journal;

  JournalCreated(this.journal);
}

class JournalUpdated extends JournalState {
  final Journal journal;

  JournalUpdated(this.journal);
}

class JournalDeleted extends JournalState {
  final String journalId;

  JournalDeleted(this.journalId);
}
