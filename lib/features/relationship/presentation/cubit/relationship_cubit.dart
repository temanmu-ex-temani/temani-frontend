import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:temani_frontend/features/relationship/domain/entities/relationship.dart';
import 'package:temani_frontend/features/relationship/domain/repositories/relationship_repository.dart';

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
    emit(state.copyWith(status: RelationshipCubitStatus.loading));

    final result = await _repository.createRelationship(targetId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RelationshipCubitStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (relationship) {
        // Reload accepted relationships after creating
        loadAcceptedRelationships();
      },
    );
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
        loadAcceptedRelationships();
      },
    );
  }
}

