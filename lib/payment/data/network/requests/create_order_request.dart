import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

/// Outbound request payload creating a purchase order at the ELYSIUM
/// `/api/v1/orders` resource.
///
/// A serialization-only boundary; marked outbound-only via
/// `createFactory: false`, so only the generated `toJson` schema is emitted.
@JsonSerializable(createFactory: false)
class CreateOrderRequest {
  /// Creates a [CreateOrderRequest].
  const CreateOrderRequest({
    required this.userAccountId,
    required this.amount,
    required this.membershipId,
  });

  /// Identifier of the purchasing user account.
  @JsonKey(name: 'user_account_id')
  final int userAccountId;

  /// Amount to charge for the order.
  @JsonKey(name: 'amount')
  final int amount;

  /// Identifier of the membership being acquired.
  @JsonKey(name: 'membership_id')
  final int membershipId;

  /// Serializes this request via the generated schema.
  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
