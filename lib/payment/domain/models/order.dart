import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing a purchase order that links a user
/// account to the membership it is acquiring.
///
/// Pure by construction, with hand-written value equality.
class Order {
  /// Creates an immutable [Order].
  const Order({
    required this.id,
    required this.userAccountId,
    required this.amount,
    required this.membershipId,
  });

  /// Stable unique identifier of the order (`order_id`).
  final Id id;

  /// Identifier of the purchasing user account (`user_account_id`).
  final Id userAccountId;

  /// Charged amount, expressed as a whole currency amount.
  final int amount;

  /// Identifier of the membership acquired by this order (`membership_id`).
  final Id membershipId;

  /// Returns a copy of this [Order] overriding only the provided fields.
  Order copyWith({
    Id? id,
    Id? userAccountId,
    int? amount,
    Id? membershipId,
  }) {
    return Order(
      id: id ?? this.id,
      userAccountId: userAccountId ?? this.userAccountId,
      amount: amount ?? this.amount,
      membershipId: membershipId ?? this.membershipId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order &&
        other.id == id &&
        other.userAccountId == userAccountId &&
        other.amount == amount &&
        other.membershipId == membershipId;
  }

  @override
  int get hashCode => Object.hash(id, userAccountId, amount, membershipId);

  @override
  String toString() =>
      'Order(id: $id, userAccountId: $userAccountId, amount: $amount)';
}
