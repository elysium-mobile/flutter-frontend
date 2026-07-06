import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing a purchasable subscription plan
/// (pricing tier) offered on the plan-selection screen.
///
/// Pure by construction: no annotations, serialization tokens or infrastructure
/// imports, with hand-written value equality mirroring the IAM conventions.
class MembershipPlan {
  /// Creates an immutable [MembershipPlan].
  const MembershipPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.membershipId,
  });

  /// Stable unique identifier of the plan (`plan_id`).
  final Id id;

  /// Commercial name of the plan (e.g. "Básico", "Plan Pro").
  final String name;

  /// Monthly price of the plan, expressed as a whole currency amount.
  final int price;

  /// Identifier of the membership period this plan provisions.
  ///
  /// Required to create the purchase [Order], whose `membership_id` links the
  /// buyer's account to the subscription being acquired.
  final Id membershipId;

  /// Returns a copy of this [MembershipPlan] overriding only the provided fields.
  MembershipPlan copyWith({
    Id? id,
    String? name,
    int? price,
    Id? membershipId,
  }) {
    return MembershipPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      membershipId: membershipId ?? this.membershipId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MembershipPlan &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.membershipId == membershipId;
  }

  @override
  int get hashCode => Object.hash(id, name, price, membershipId);

  @override
  String toString() =>
      'MembershipPlan(id: $id, name: $name, price: $price)';
}
