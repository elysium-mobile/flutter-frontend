part of 'add_card_bloc.dart';

/// Base type for every intent the card-provisioning form dispatches.
sealed class AddCardEvent extends Equatable {
  /// Const constructor for subclasses.
  const AddCardEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The cardholder-name field changed.
final class AddCardHolderChanged extends AddCardEvent {
  /// Creates an [AddCardHolderChanged].
  const AddCardHolderChanged(this.value);

  /// Latest cardholder value.
  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

/// The card-number field changed.
final class AddCardNumberChanged extends AddCardEvent {
  /// Creates an [AddCardNumberChanged].
  const AddCardNumberChanged(this.value);

  /// Latest card-number value (may contain spacing).
  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

/// The expiration-date field changed.
final class AddCardExpiryChanged extends AddCardEvent {
  /// Creates an [AddCardExpiryChanged].
  const AddCardExpiryChanged(this.value);

  /// Latest expiry value (e.g. `08 / 2028`).
  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

/// The security-code (CVV) field changed.
final class AddCardCvvChanged extends AddCardEvent {
  /// Creates an [AddCardCvvChanged].
  const AddCardCvvChanged(this.value);

  /// Latest CVV value.
  final String value;

  @override
  List<Object?> get props => <Object?>[value];
}

/// The "Save this card" switch toggled.
final class AddCardSaveToggled extends AddCardEvent {
  /// Creates an [AddCardSaveToggled].
  const AddCardSaveToggled(this.value);

  /// Whether the card should be persisted.
  final bool value;

  @override
  List<Object?> get props => <Object?>[value];
}

/// The "Agregar método" button was pressed.
final class AddCardSubmitted extends AddCardEvent {
  /// Creates an [AddCardSubmitted].
  const AddCardSubmitted();
}
