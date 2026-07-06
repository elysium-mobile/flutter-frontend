import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/membership.dart';
import '../../domain/models/membership_plan.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_methods_event.dart';
part 'payment_methods_state.dart';

/// Business Logic Component orchestrating the payment-methods ("Métodos de
/// pago") overview screen.
///
/// Loads the billing overview (current membership, the plan backing it and the
/// saved cards) and handles subscription cancellation. Views react to
/// [PaymentMethodsStatus]; navigation is left to the presentation layer.
class PaymentMethodsBloc
    extends Bloc<PaymentMethodsEvent, PaymentMethodsState> {
  /// Creates a [PaymentMethodsBloc] bound to the [PaymentRepository] port.
  PaymentMethodsBloc({required PaymentRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const PaymentMethodsState()) {
    on<PaymentMethodsStarted>(_onStarted);
    on<PaymentMethodsSubscriptionCancelled>(_onSubscriptionCancelled);
  }

  final PaymentRepository _repository;

  /// Loads the billing overview and saved cards.
  Future<void> _onStarted(
    PaymentMethodsStarted event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    emit(state.copyWith(status: PaymentMethodsStatus.loading, errorMessage: null));
    try {
      final membership = await _repository.loadCurrentMembership();
      final plans = await _repository.loadPlans();
      final cards = await _repository.loadSavedCards();
      emit(state.copyWith(
        status: PaymentMethodsStatus.ready,
        membership: membership,
        billingPlan: _matchingPlan(plans, membership),
        cards: cards,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PaymentMethodsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Cancels the active subscription and reloads the overview.
  Future<void> _onSubscriptionCancelled(
    PaymentMethodsSubscriptionCancelled event,
    Emitter<PaymentMethodsState> emit,
  ) async {
    try {
      await _repository.cancelSubscription();
      add(const PaymentMethodsStarted());
    } catch (error) {
      emit(state.copyWith(
        status: PaymentMethodsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Finds the plan whose membership matches [membership], to source the
  /// next-charge amount for the billing banner.
  static MembershipPlan? _matchingPlan(
    List<MembershipPlan> plans,
    Membership? membership,
  ) {
    if (membership == null) return null;
    for (final MembershipPlan plan in plans) {
      if (plan.membershipId == membership.id) return plan;
    }
    return null;
  }
}
