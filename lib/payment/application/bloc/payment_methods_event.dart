part of 'payment_methods_bloc.dart';

/// Base type for every intent the payment-methods screen dispatches.
sealed class PaymentMethodsEvent extends Equatable {
  /// Const constructor for subclasses.
  const PaymentMethodsEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The screen was opened (or needs a refresh); load the billing overview.
final class PaymentMethodsStarted extends PaymentMethodsEvent {
  /// Creates a [PaymentMethodsStarted].
  const PaymentMethodsStarted();
}

/// The "Cancelar suscripción" button was pressed.
final class PaymentMethodsSubscriptionCancelled extends PaymentMethodsEvent {
  /// Creates a [PaymentMethodsSubscriptionCancelled].
  const PaymentMethodsSubscriptionCancelled();
}
