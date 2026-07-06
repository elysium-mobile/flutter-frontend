part of 'payment_methods_bloc.dart';

/// Lifecycle status of the payment-methods overview.
enum PaymentMethodsStatus {
  /// Nothing has been requested yet.
  initial,

  /// The overview is being loaded.
  loading,

  /// The overview is available.
  ready,

  /// A load or cancellation failed; inspect [PaymentMethodsState.errorMessage].
  failure,
}

/// Immutable state of the payment-methods screen managed by
/// [PaymentMethodsBloc].
final class PaymentMethodsState extends Equatable {
  /// Creates a [PaymentMethodsState].
  const PaymentMethodsState({
    this.status = PaymentMethodsStatus.initial,
    this.membership,
    this.billingPlan,
    this.cards = const <PaymentCard>[],
    this.errorMessage,
  });

  /// Current lifecycle status of the flow.
  final PaymentMethodsStatus status;

  /// The synchronized membership, or `null` when none exists.
  final Membership? membership;

  /// Plan backing [membership], used for the next-charge amount, or `null`.
  final MembershipPlan? billingPlan;

  /// Saved cards (non-sensitive display fields only).
  final List<PaymentCard> cards;

  /// Raw diagnostic error message when [status] is
  /// [PaymentMethodsStatus.failure].
  final String? errorMessage;

  /// Next-charge date derived from the membership period, or `null`.
  DateTime? get nextChargeDate => membership?.over;

  /// Next-charge amount derived from the billing plan, or `null`.
  int? get nextChargeAmount => billingPlan?.price;

  /// Returns a copy overriding the provided fields. [membership], [billingPlan]
  /// and [errorMessage] use a sentinel so they can be explicitly cleared.
  PaymentMethodsState copyWith({
    PaymentMethodsStatus? status,
    Object? membership = _sentinel,
    Object? billingPlan = _sentinel,
    List<PaymentCard>? cards,
    Object? errorMessage = _sentinel,
  }) {
    return PaymentMethodsState(
      status: status ?? this.status,
      membership: identical(membership, _sentinel)
          ? this.membership
          : membership as Membership?,
      billingPlan: identical(billingPlan, _sentinel)
          ? this.billingPlan
          : billingPlan as MembershipPlan?,
      cards: cards ?? this.cards,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        membership,
        billingPlan,
        cards,
        errorMessage,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
