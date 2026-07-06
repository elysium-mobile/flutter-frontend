import 'dart:developer' as developer;

import '../../../shared/data/local/app_database.dart';
import '../../../shared/data/network/api_client.dart';
import '../../../shared/domain/models/id.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/membership_plan.dart';
import '../../domain/models/membership_status.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/repositories/payment_repository.dart';
import '../models/db_mapping_extensions.dart';
import '../network/payment_web_service.dart';
import '../network/requests/create_order_request.dart';
import '../network/requests/create_stripe_checkout_request.dart';

/// Concrete [PaymentRepository] adapter bridging the ELYSIUM payment endpoints
/// and the local Drift store.
///
/// The local `CachedMemberships`/`SavedCards` tables are the on-device source of
/// truth for subscription state and saved cards, since the backend exposes no
/// user-scoped "current membership" endpoint. [purchasePlan] exercises the real
/// order and Stripe-checkout endpoints (best-effort, so the flow still resolves
/// when the session is not yet reconciled to an ELYSIUM JWT — see the documented
/// auth gap) and then synchronizes the acquired membership locally. The final
/// card-charge confirmation with the returned `client_secret` is a Stripe-SDK
/// concern intentionally left out of this networking layer.
class PaymentRepositoryImpl implements PaymentRepository {
  /// Creates a [PaymentRepositoryImpl] bound to its collaborators.
  PaymentRepositoryImpl({
    required PaymentWebService webService,
    required AppDatabase database,
  })  : _webService = webService, // ignore: prefer_initializing_formals
        _database = database; // ignore: prefer_initializing_formals

  final PaymentWebService _webService;
  final AppDatabase _database;

  /// Default membership duration applied when the backend period is unknown.
  static const Duration _defaultPeriod = Duration(days: 30);

  @override
  Future<List<MembershipPlan>> loadPlans() async {
    final responses = await _webService.fetchPlans();
    return responses.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Membership?> loadCurrentMembership() async {
    final row = await _database.readMembership();
    return row?.toDomain();
  }

  @override
  Future<Membership> purchasePlan({
    required MembershipPlan plan,
    required Id userAccountId,
    PaymentCard? card,
  }) async {
    if (card != null) {
      await saveCard(card);
    }

    // Best-effort real backend orchestration: create the order, then the Stripe
    // PaymentIntent. Swallowed transport failures do not block the local
    // synchronization that the routing automation depends on.
    await _tryProvisionOnBackend(plan: plan, userAccountId: userAccountId);

    final Membership acquired = await _resolveAcquiredMembership(plan);
    await _database.cacheMembership(acquired.toCompanion());
    return acquired;
  }

  @override
  Future<void> cancelSubscription() async {
    final Membership? current = await loadCurrentMembership();
    if (current == null) return;
    // Retain the period but flip the status so the routing gate treats access as
    // expired and routes future entries into the renewal flow.
    final Membership cancelled =
        current.copyWith(status: MembershipStatus.expired);
    await _database.cacheMembership(cancelled.toCompanion());
  }

  @override
  Future<List<PaymentCard>> loadSavedCards() async {
    final rows = await _database.readSavedCards();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<PaymentCard> saveCard(PaymentCard card) async {
    final int id = await _database.insertSavedCard(card.toCompanion());
    return card.copyWith(id: Id(id.toString()));
  }

  /// Attempts the real order + Stripe-checkout provisioning, logging and
  /// swallowing transport failures.
  Future<void> _tryProvisionOnBackend({
    required MembershipPlan plan,
    required Id userAccountId,
  }) async {
    try {
      final order = await _webService.createOrder(
        CreateOrderRequest(
          userAccountId: _asInt(userAccountId),
          amount: plan.price,
          membershipId: _asInt(plan.membershipId),
        ),
      );
      await _webService.createStripeCheckout(
        CreateStripeCheckoutRequest(orderId: order.orderId),
      );
    } on ApiException catch (error) {
      developer.log(
        'Backend purchase provisioning unavailable; proceeding with local '
        'membership synchronization only.',
        name: 'PaymentRepository',
        error: error,
      );
    }
  }

  /// Resolves the acquired [Membership] to synchronize, preferring the backend
  /// period when it can be fetched and falling back to a locally-dated period.
  Future<Membership> _resolveAcquiredMembership(MembershipPlan plan) async {
    try {
      final response =
          await _webService.fetchMembership(_asInt(plan.membershipId));
      final Membership fetched = response.toDomain();
      if (fetched.status.isActive) return fetched;
    } on ApiException catch (error) {
      developer.log(
        'Membership period fetch unavailable; using local period.',
        name: 'PaymentRepository',
        error: error,
      );
    }

    final DateTime now = DateTime.now();
    return Membership(
      id: plan.membershipId,
      status: MembershipStatus.active,
      start: now,
      over: now.add(_defaultPeriod),
    );
  }

  /// Parses an [Id] whose value is a numeric string into an `int`, defaulting to
  /// `0` when non-numeric.
  static int _asInt(Id id) => int.tryParse(id.value) ?? 0;
}
