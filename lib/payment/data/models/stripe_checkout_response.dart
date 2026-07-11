import 'package:json_annotation/json_annotation.dart';

part 'stripe_checkout_response.g.dart';

/// Inbound network contract describing the Stripe **Checkout Session** payload
/// returned by the ELYSIUM `/api/v1/payments/stripe/checkout` resource.
///
/// As of the 2026-07-10 backend migration from PaymentIntent + Stripe.js to a
/// hosted Checkout Session, the response no longer carries a `client_secret`.
/// Instead it returns the hosted [checkoutUrl] the customer is redirected to and
/// the [sessionId] usable for frontend verification. A raw serialization
/// boundary, inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class StripeCheckoutResponse {
  /// Creates a [StripeCheckoutResponse] from its explicit wire fields.
  const StripeCheckoutResponse({
    required this.checkoutUrl,
    required this.sessionId,
  });

  /// Hosted Stripe Checkout page URL — the customer is redirected here to
  /// complete payment (card entry, 3D Secure, confirmation) on Stripe's page.
  @JsonKey(name: 'checkout_url')
  final String checkoutUrl;

  /// Stripe Checkout Session ID (`cs_...`), usable for frontend verification.
  @JsonKey(name: 'session_id')
  final String sessionId;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory StripeCheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$StripeCheckoutResponseFromJson(json);
}
