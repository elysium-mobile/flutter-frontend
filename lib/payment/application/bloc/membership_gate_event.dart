part of 'membership_gate_bloc.dart';

/// Base type for every intent driving the [MembershipGateBloc].
sealed class MembershipGateEvent extends Equatable {
  /// Const constructor for subclasses.
  const MembershipGateEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Re-resolve the membership status (session became active or data changed).
final class MembershipGateRefreshed extends MembershipGateEvent {
  /// Creates a [MembershipGateRefreshed].
  const MembershipGateRefreshed();
}

/// Optimistically mark the gate active with a freshly acquired membership.
final class MembershipGateActivated extends MembershipGateEvent {
  /// Creates a [MembershipGateActivated].
  const MembershipGateActivated(this.membership);

  /// The membership acquired by the completed purchase.
  final Membership membership;

  @override
  List<Object?> get props => <Object?>[membership];
}

/// Reset the gate when the session ends.
final class MembershipGateCleared extends MembershipGateEvent {
  /// Creates a [MembershipGateCleared].
  const MembershipGateCleared();
}
