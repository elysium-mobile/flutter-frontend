part of 'add_card_bloc.dart';

/// Lifecycle status of the card-provisioning form.
enum AddCardStatus {
  /// The form is idle and editable.
  editing,

  /// The card is being persisted.
  submitting,

  /// The card was added successfully.
  success,

  /// Adding the card failed; inspect [AddCardState.errorMessage].
  failure,
}

/// Immutable state of the card-provisioning form managed by [AddCardBloc].
final class AddCardState extends Equatable {
  /// Creates an [AddCardState].
  const AddCardState({
    this.cardHolder = '',
    this.cardNumber = '',
    this.expiry = '',
    this.cvv = '',
    this.saveCard = false,
    this.status = AddCardStatus.editing,
    this.errorMessage,
    this.savedCard,
  });

  /// Current cardholder-name value.
  final String cardHolder;

  /// Current card-number value (may contain spacing).
  final String cardNumber;

  /// Current expiry value (e.g. `08 / 2028`).
  final String expiry;

  /// Current security-code value.
  final String cvv;

  /// Whether the card should be persisted on submission.
  final bool saveCard;

  /// Current lifecycle status.
  final AddCardStatus status;

  /// Raw diagnostic error message when [status] is [AddCardStatus.failure].
  final String? errorMessage;

  /// The resulting card when [status] is [AddCardStatus.success].
  final PaymentCard? savedCard;

  /// The card number reduced to its digits.
  String get digitsOnlyNumber => cardNumber.replaceAll(RegExp(r'\D'), '');

  /// The expiry split into `[month, year]` digit groups (padded/empty-safe).
  List<String> get expiryParts {
    final List<String> groups = expiry
        .split(RegExp(r'\D+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    final String month = groups.isNotEmpty ? groups.first : '';
    final String year = groups.length > 1 ? groups[1] : '';
    return <String>[month, year];
  }

  /// Whether every field passes basic client-side validation.
  bool get isValid {
    final String digits = digitsOnlyNumber;
    final List<String> parts = expiryParts;
    final bool expiryOk = parts.first.isNotEmpty &&
        parts.first.length <= 2 &&
        parts.last.length == 4;
    return cardHolder.trim().isNotEmpty &&
        digits.length >= 13 &&
        digits.length <= 19 &&
        expiryOk &&
        cvv.length >= 3 &&
        cvv.length <= 4;
  }

  /// Whether the form can be submitted (valid and not mid-submission).
  bool get canSubmit => isValid && status != AddCardStatus.submitting;

  /// Returns a copy overriding the provided fields. [errorMessage]/[savedCard]
  /// use a sentinel so they can be explicitly cleared to `null`.
  AddCardState copyWith({
    String? cardHolder,
    String? cardNumber,
    String? expiry,
    String? cvv,
    bool? saveCard,
    AddCardStatus? status,
    Object? errorMessage = _sentinel,
    Object? savedCard = _sentinel,
  }) {
    return AddCardState(
      cardHolder: cardHolder ?? this.cardHolder,
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      saveCard: saveCard ?? this.saveCard,
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      savedCard: identical(savedCard, _sentinel)
          ? this.savedCard
          : savedCard as PaymentCard?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        cardHolder,
        cardNumber,
        expiry,
        cvv,
        saveCard,
        status,
        errorMessage,
        savedCard,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
