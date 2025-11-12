part of 'relationship_cubit.dart';

enum RelationshipCubitStatus { initial, loading, success, error }

class RelationshipState extends Equatable {
  final RelationshipCubitStatus status;
  final List<Relationship> acceptedRelationships;
  final String? errorMessage;

  const RelationshipState({
    this.status = RelationshipCubitStatus.initial,
    this.acceptedRelationships = const [],
    this.errorMessage,
  });

  RelationshipState copyWith({
    RelationshipCubitStatus? status,
    List<Relationship>? acceptedRelationships,
    String? errorMessage,
  }) {
    return RelationshipState(
      status: status ?? this.status,
      acceptedRelationships:
          acceptedRelationships ?? this.acceptedRelationships,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, acceptedRelationships, errorMessage];
}

