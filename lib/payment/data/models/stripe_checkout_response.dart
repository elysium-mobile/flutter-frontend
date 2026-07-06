import 'package:json_annotation/json_annotation.dart';

part 'stripe_checkout_response.g.dart';

/// Inbound network contract describing the Stripe checkout payload returned by
/// the ELYSIUM `/api/v1/payments/stripe/checkout` resource.
///
/// Carries the `client_secret` the client uses to confirm the payment with the
/// Stripe SDK. A raw serialization boundary, inbound-only
/// (`createToJson: false`).
@JsonSerializable(createToJson: false)
class StripeCheckoutResponse {
  /// Creates a [StripeCheckoutResponse] from its explicit wire field.
  const StripeCheckoutResponse({required this.clientSecret});

  /// Stripe PaymentIntent client secret used to confirm the charge client-side.
  @JsonKey(name: 'client_secret')
  final String clientSecret;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory StripeCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$StripeCheckoutResponseFromJson(json);
}
