import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/order.dart';

part 'order_response.g.dart';

/// Inbound network contract describing the order payload returned by the ELYSIUM
/// `/api/v1/orders` resource.
///
/// A raw serialization boundary mirroring the snake_case wire schema. Marked
/// inbound-only (`createToJson: false`); projection is exposed via [toDomain].
@JsonSerializable(createToJson: false)
class OrderResponse {
  /// Creates an [OrderResponse] from its explicit wire fields.
  const OrderResponse({
    required this.orderId,
    required this.userAccountId,
    required this.amount,
    required this.membershipId,
  });

  /// Server-driven unique identifier of the order.
  @JsonKey(name: 'order_id')
  final int orderId;

  /// Identifier of the purchasing user account.
  @JsonKey(name: 'user_account_id')
  final int userAccountId;

  /// Charged amount.
  @JsonKey(name: 'amount')
  final int amount;

  /// Identifier of the membership acquired by this order.
  @JsonKey(name: 'membership_id')
  final int membershipId;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [Order] entity.
  Order toDomain() {
    return Order(
      id: Id(orderId.toString()),
      userAccountId: Id(userAccountId.toString()),
      amount: amount,
      membershipId: Id(membershipId.toString()),
    );
  }
}
