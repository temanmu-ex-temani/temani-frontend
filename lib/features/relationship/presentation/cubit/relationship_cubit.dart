import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temanmu/features/relationship/domain/entities/relationship.dart';
import 'package:temanmu/features/relationship/domain/repositories/relationship_repository.dart';

part 'relationship_state.dart';

@injectable
class RelationshipCubit extends Cubit<RelationshipState> {
  final RelationshipRepository _repository;

  RelationshipCubit({required RelationshipRepository repository})
      : _repository = repository,
        super(const RelationshipState());

  Future<void> loadAcceptedRelationships() async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.getRelationships(status: 'accepted');

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (relationships) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.success,
          acceptedRelationships: relationships,
        ),
      ),
    );
  }

  Future<void> createRelationship(String targetId) async {
    print('[RelationshipCubit] createRelationship called');
    print('[RelationshipCubit] targetId: $targetId');
    print('[RelationshipCubit] Current state: ${state.status}');
    
    emit(state.copyWith(status: RelationshipCubitStatus.loading));
    print('[RelationshipCubit] Emitted loading state');

    try {
      print('[RelationshipCubit] Calling repository.createRelationship...');
      final result = await _repository.createRelationship(targetId);
      print('[RelationshipCubit] Repository call completed');

      result.fold(
        (failure) {
          print('[RelationshipCubit] Relationship creation failed');
          print('[RelationshipCubit] Failure type: ${failure.runtimeType}');
          print('[RelationshipCubit] Failure message: ${failure.message}');
          emit(
            state.copyWith(
              status: RelationshipCubitStatus.error,
              errorMessage: failure.message,
            ),
          );
          print('[RelationshipCubit] Emitted error state with message: ${failure.message}');
        },
        (relationship) {
          print('[RelationshipCubit] Relationship creation successful');
          print('[RelationshipCubit] Relationship ID: ${relationship.id}');
          print('[RelationshipCubit] Relationship accepted: ${relationship.accepted}');
          print('[RelationshipCubit] Client ID: ${relationship.clientId}');
          print('[RelationshipCubit] Caregiver ID: ${relationship.caregiverId}');
          // Reload accepted relationships after creating
          loadAcceptedRelationships();
        },
      );
    } catch (e, stackTrace) {
      print('[RelationshipCubit] Exception in createRelationship: $e');
      print('[RelationshipCubit] Stack trace: $stackTrace');
      emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: 'Unexpected error: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> acceptRelationship(String id) async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.updateRelationshipStatus(id, 'ACCEPT');

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload after accepting
        loadAcceptedRelationships();
      },
    );
  }

  Future<void> rejectRelationship(String id) async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.updateRelationshipStatus(id, 'REJECT');

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload after rejecting
        loadPendingReceivedRelationships();
      },
    );
  }

  Future<void> cancelRelationship(String id) async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.updateRelationshipStatus(id, 'CANCEL');

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload after canceling
        loadPendingSentRelationships();
      },
    );
  }

  Future<void> deleteRelationship(String id) async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.deleteRelationship(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Reload after deleting
        loadAcceptedRelationships();
      },
    );
  }

  Future<void> loadPendingSentRelationships() async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.getRelationships(
      status: 'pending',
      direction: 'sent',
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (relationships) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.success,
          pendingSentRelationships: relationships,
        ),
      ),
    );
  }

  Future<void> loadPendingReceivedRelationships() async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.getRelationships(
      status: 'pending',
      direction: 'received',
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (relationships) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.success,
          pendingReceivedRelationships: relationships,
        ),
      ),
    );
  }

  Future<void> searchPotentialRelationships(String role, {String? keyword}) async {
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.searchRelationships(role, keyword: keyword);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (potentialRelationships) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.success,
          potentialRelationships: potentialRelationships,
        ),
      ),
    );
  }

  Future<void> loadAllRelationships() async {
    await Future.wait([
      loadAcceptedRelationships(),
      loadPendingSentRelationships(),
      loadPendingReceivedRelationships(),
    ]);
  }
}

