part of 'relationship_cubit.dart';

enum RelationshipCubitStatus { initial, loading, success, error }

class RelationshipState extends Equatable {
  final RelationshipCubitStatus status;
  final List<Relationship> acceptedRelationships;
  final List<Relationship> pendingSentRelationships;
  final List<Relationship> pendingReceivedRelationships;
  final List<PotentialRelationship> potentialRelationships;
  final String? errorMessage;

  const RelationshipState({
    this.status = RelationshipCubitStatus.initial,
    this.acceptedRelationships = const [],
    this.pendingSentRelationships = const [],
    this.pendingReceivedRelationships = const [],
    this.potentialRelationships = const [],
    this.errorMessage,
  });

  RelationshipState copyWith({
    RelationshipCubitStatus? status,
    List<Relationship>? acceptedRelationships,
    List<Relationship>? pendingSentRelationships,
    List<Relationship>? pendingReceivedRelationships,
    List<PotentialRelationship>? potentialRelationships,
    String? errorMessage,
  }) {
    return RelationshipState(
      status: status ?? this.status,
      acceptedRelationships:
          acceptedRelationships ?? this.acceptedRelationships,
      pendingSentRelationships:
          pendingSentRelationships ?? this.pendingSentRelationships,
      pendingReceivedRelationships:
          pendingReceivedRelationships ?? this.pendingReceivedRelationships,
      potentialRelationships:
          potentialRelationships ?? this.potentialRelationships,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        acceptedRelationships,
        pendingSentRelationships,
        pendingReceivedRelationships,
        potentialRelationships,
        errorMessage,
      ];
}

