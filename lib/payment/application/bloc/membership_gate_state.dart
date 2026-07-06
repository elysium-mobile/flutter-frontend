part of 'membership_gate_bloc.dart';

/// Membership access classification consulted by the router.
enum MembershipGateStatus {
  /// Not yet resolved (unauthenticated or pre-bootstrap).
  unknown,

  /// The membership is being resolved.
  resolving,

  /// An active membership grants full access.
  active,

  /// A membership exists but has expired or been cancelled (renewal required).
  expired,

  /// No membership has ever been acquired on this device.
  absent,
}

/// Immutable state exposed by [MembershipGateBloc].
final class MembershipGateState extends Equatable {
  /// Creates a [MembershipGateState].
  const MembershipGateState({required this.status, this.membership});

  /// Creates the initial, unresolved state.
  const MembershipGateState.unknown()
      : status = MembershipGateStatus.unknown,
        membership = null;

  /// Current membership access classification.
  final MembershipGateStatus status;

  /// The resolved membership, when one is known.
  final Membership? membership;

  /// Whether access must be intercepted into the renewal flow.
  ///
  /// True only when a membership positively resolved as expired; never for the
  /// indeterminate ([unknown]/[resolving]) or new-user ([absent]) states.
  bool get requiresRenewal => status == MembershipGateStatus.expired;

  /// Returns a copy overriding the provided fields.
  MembershipGateState copyWith({
    MembershipGateStatus? status,
    Membership? membership,
  }) {
    return MembershipGateState(
      status: status ?? this.status,
      membership: membership ?? this.membership,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, membership];
}
