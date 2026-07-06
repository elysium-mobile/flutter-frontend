import '../../../shared/domain/models/id.dart';
import '../models/membership.dart';
import '../models/membership_plan.dart';
import '../models/payment_card.dart';

/// Port (hexagonal) describing the payment and subscription capabilities
/// required by the payment application layer.
///
/// Expressed purely in terms of domain types: BLoCs depend on this contract,
/// never on the concrete network/Drift adapter. Implementations live in
/// `data/repositories/` and are responsible for orchestrating the ELYSIUM
/// order/checkout endpoints and synchronizing the acquired membership and saved
/// cards into the local Drift store.
///
/// Operations communicate failure by throwing an [Exception]; the BLoCs catch it
/// once and reduce it into a renderable error state.
abstract interface class PaymentRepository {
  /// Loads the subscription plans offered on the plan-selection screen.
  Future<List<MembershipPlan>> loadPlans();

  /// Returns the membership currently synchronized for this device, or `null`
  /// when the user has never acquired one.
  ///
  /// Backs the routing automation (onboarding guard and renewal interceptor).
  Future<Membership?> loadCurrentMembership();

  /// Purchases [plan] for the account identified by [userAccountId].
  ///
  /// Orchestrates the real backend flow — create order, then create the Stripe
  /// checkout intent — and, on success, synchronizes the acquired [Membership]
  /// into the local Drift store. When [card] is provided it is persisted first
  /// (non-sensitive fields only). Returns the acquired membership.
  Future<Membership> purchasePlan({
    required MembershipPlan plan,
    required Id userAccountId,
    PaymentCard? card,
  });

  /// Cancels the active subscription, marking the synchronized membership as no
  /// longer active.
  Future<void> cancelSubscription();

  /// Loads the saved payment cards (non-sensitive display fields only).
  Future<List<PaymentCard>> loadSavedCards();

  /// Persists [card] to the local Drift store and returns it with its assigned
  /// identifier. Only the last four digits, holder, expiry and brand are stored.
  Future<PaymentCard> saveCard(PaymentCard card);
}
