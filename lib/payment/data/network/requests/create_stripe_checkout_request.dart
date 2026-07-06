import 'package:json_annotation/json_annotation.dart';

part 'create_stripe_checkout_request.g.dart';

/// Outbound request payload creating a Stripe PaymentIntent at the ELYSIUM
/// `/api/v1/payments/stripe/checkout` resource.
///
/// A serialization-only boundary; marked outbound-only via
/// `createFactory: false`. The currency defaults to `usd` server-side when
/// omitted, but is sent explicitly here for determinism.
@JsonSerializable(createFactory: false)
class CreateStripeCheckoutRequest {
  /// Creates a [CreateStripeCheckoutRequest].
  const CreateStripeCheckoutRequest({
    required this.orderId,
    this.currency = 'usd',
  });

  /// Identifier of the order the payment intent settles.
  @JsonKey(name: 'order_id')
  final int orderId;

  /// ISO 4217 currency code (lowercased by the backend before Stripe).
  @JsonKey(name: 'currency')
  final String currency;

  /// Serializes this request via the generated schema.
  Map<String, dynamic> toJson() => _$CreateStripeCheckoutRequestToJson(this);
}
