import '../../../shared/domain/models/id.dart';
import 'membership_status.dart';

/// Immutable core domain entity describing an acquired subscription membership
/// period and its access-granting status.
///
/// Drives the routing automation: the gate reads [isCurrentlyActive] to decide
/// whether onboarding must be forced or a renewal intercepted. Pure by
/// construction, with hand-written value equality.
class Membership {
  /// Creates an immutable [Membership].
  const Membership({
    required this.id,
    required this.status,
    this.start,
    this.over,
  });

  /// Stable unique identifier of the membership (`membership_id`).
  final Id id;

  /// Normalized lifecycle status of the membership.
  final MembershipStatus status;

  /// Inclusive start date of the membership period, if known.
  final DateTime? start;

  /// Exclusive end date of the membership period, if known (`membership_over`).
  final DateTime? over;

  /// Whether the membership currently grants access.
  ///
  /// Requires both an [MembershipStatus.active] status and — when the end date
  /// is known — an [over] date that has not yet passed.
  bool get isCurrentlyActive {
    if (!status.isActive) return false;
    final DateTime? end = over;
    if (end == null) return true;
    return DateTime.now().isBefore(end);
  }

  /// Returns a copy of this [Membership] overriding only the provided fields.
  Membership copyWith({
    Id? id,
    MembershipStatus? status,
    DateTime? start,
    DateTime? over,
  }) {
    return Membership(
      id: id ?? this.id,
      status: status ?? this.status,
      start: start ?? this.start,
      over: over ?? this.over,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Membership &&
        other.id == id &&
        other.status == status &&
        other.start == start &&
        other.over == over;
  }

  @override
  int get hashCode => Object.hash(id, status, start, over);

  @override
  String toString() =>
      'Membership(id: $id, status: $status, start: $start, over: $over)';
}
