import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing a saved payment card, reduced to its
/// non-sensitive display attributes.
///
/// For PCI-safety the domain deliberately models only the data that is safe to
/// persist and render: the last four digits, the cardholder name, the expiry and
/// the brand. The full primary account number (PAN) and the security code (CVV)
/// are never represented here nor stored locally. Pure by construction.
class PaymentCard {
  /// Creates an immutable [PaymentCard].
  const PaymentCard({
    required this.id,
    required this.cardHolder,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.brand,
  });

  /// Stable local identifier of the saved card, or an empty [Id] when unsaved.
  final Id id;

  /// Name embossed on the card.
  final String cardHolder;

  /// Last four digits of the primary account number.
  final String last4;

  /// Two-digit expiry month (`01`..`12`).
  final String expiryMonth;

  /// Four-digit expiry year.
  final String expiryYear;

  /// Detected card brand (e.g. "VISA", "MASTERCARD").
  final String brand;

  /// Masked display representation, e.g. `**** **** **** 8790`.
  String get maskedNumber => '**** **** **** $last4';

  /// Human-readable expiry, e.g. `01 / 22`.
  String get formattedExpiry => '$expiryMonth / $expiryYear';

  /// Returns a copy of this [PaymentCard] overriding only the provided fields.
  PaymentCard copyWith({
    Id? id,
    String? cardHolder,
    String? last4,
    String? expiryMonth,
    String? expiryYear,
    String? brand,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      cardHolder: cardHolder ?? this.cardHolder,
      last4: last4 ?? this.last4,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      brand: brand ?? this.brand,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentCard &&
        other.id == id &&
        other.cardHolder == cardHolder &&
        other.last4 == last4 &&
        other.expiryMonth == expiryMonth &&
        other.expiryYear == expiryYear &&
        other.brand == brand;
  }

  @override
  int get hashCode =>
      Object.hash(id, cardHolder, last4, expiryMonth, expiryYear, brand);

  @override
  String toString() =>
      'PaymentCard(id: $id, brand: $brand, last4: $last4)';
}
