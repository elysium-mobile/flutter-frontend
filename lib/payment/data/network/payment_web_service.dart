import '../../../shared/data/network/api_client.dart';
import '../models/membership_plan_response.dart';
import '../models/membership_response.dart';
import '../models/order_response.dart';
import '../models/stripe_checkout_response.dart';
import 'requests/create_order_request.dart';
import 'requests/create_stripe_checkout_request.dart';

/// Payment network mappings layered on top of the shared [ApiClient].
///
/// Targets the ELYSIUM membership-plan, order, Stripe-checkout and membership
/// resources and decodes their payloads into the corresponding `*Response`
/// types. All transport concerns (headers, bearer token, logging, error
/// normalization) are delegated to the centralized client.
class PaymentWebService {
  /// Creates a [PaymentWebService] bound to the shared [ApiClient].
  PaymentWebService(this._apiClient);

  final ApiClient _apiClient;

  /// Relative endpoint listing the subscription plans.
  static const String _membershipPlansPath = '/membership-plans';

  /// Relative endpoint listing the membership periods.
  static const String _membershipsPath = '/memberships';

  /// Relative endpoint creating purchase orders.
  static const String _ordersPath = '/orders';

  /// Relative endpoint creating a Stripe PaymentIntent for an order.
  static const String _stripeCheckoutPath = '/payments/stripe/checkout';

  /// Fetches the full list of plans as raw [MembershipPlanResponse] payloads.
  Future<List<MembershipPlanResponse>> fetchPlans() async {
    final json = await _apiClient.getList(_membershipPlansPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(MembershipPlanResponse.fromJson)
        .toList();
  }

  /// Fetches the full list of membership periods as [MembershipResponse]
  /// payloads.
  Future<List<MembershipResponse>> fetchMemberships() async {
    final json = await _apiClient.getList(_membershipsPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(MembershipResponse.fromJson)
        .toList();
  }

  /// Fetches a single membership period by [membershipId].
  Future<MembershipResponse> fetchMembership(int membershipId) async {
    final json = await _apiClient.get('$_membershipsPath/$membershipId');
    return MembershipResponse.fromJson(json);
  }

  /// Creates a purchase order and returns the decoded [OrderResponse].
  Future<OrderResponse> createOrder(CreateOrderRequest request) async {
    final json = await _apiClient.post(_ordersPath, body: request.toJson());
    return OrderResponse.fromJson(json);
  }

  /// Creates a Stripe PaymentIntent and returns the decoded
  /// [StripeCheckoutResponse] carrying the client secret.
  Future<StripeCheckoutResponse> createStripeCheckout(
    CreateStripeCheckoutRequest request,
  ) async {
    final json =
        await _apiClient.post(_stripeCheckoutPath, body: request.toJson());
    return StripeCheckoutResponse.fromJson(json);
  }
}
