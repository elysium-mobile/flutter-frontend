import 'package:go_router/go_router.dart';

import '../views/add_card_view.dart';
import '../views/membership_acquired_view.dart';
import '../views/payment_methods_view.dart';
import '../views/plan_selection_view.dart';
import 'payment_routes.dart';

/// Feature-scoped `go_router` route registration for the payment context.
///
/// Exposes the authenticated full-screen payment routes so the application
/// router can compose them alongside the shell. The success screen's CTA is
/// wired to reset navigation to the authenticated initial menu, whose route name
/// is injected to avoid a dependency on the application router.
abstract final class PaymentRouter {
  /// The full-screen payment routes (plan selection, methods, add card,
  /// success). [menuRouteName] is the symbolic name of the authenticated
  /// initial-menu route the success screen resets to.
  static List<RouteBase> authenticatedRoutes({
    required String menuRouteName,
  }) {
    return <RouteBase>[
      GoRoute(
        path: PaymentRoutes.plansPath,
        name: PaymentRoutes.plansName,
        builder: (context, state) => const PlanSelectionView(),
      ),
      GoRoute(
        path: PaymentRoutes.methodsPath,
        name: PaymentRoutes.methodsName,
        builder: (context, state) => const PaymentMethodsView(),
      ),
      GoRoute(
        path: PaymentRoutes.addCardPath,
        name: PaymentRoutes.addCardName,
        builder: (context, state) => const AddCardView(),
      ),
      GoRoute(
        path: PaymentRoutes.successPath,
        name: PaymentRoutes.successName,
        builder: (context, state) => MembershipAcquiredView(
          onContinue: () => context.goNamed(menuRouteName),
        ),
      ),
    ];
  }
}
