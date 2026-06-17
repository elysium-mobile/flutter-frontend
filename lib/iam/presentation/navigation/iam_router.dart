import 'package:go_router/go_router.dart';

import '../views/login_view.dart';
import '../views/registration_view.dart';
import 'iam_routes.dart';

/// Feature-scoped `go_router` route registration map for the IAM context.
///
/// Exposes the unauthenticated authentication-flow routes (login and
/// registration) so the application router can compose them into the
/// unauthenticated shell. Cross-route navigation by symbolic name (e.g. to the
/// success interstitials defined by the app router) resolves globally, so those
/// routes need not be declared here.
abstract final class IamRouter {
  /// The login and registration routes of the unauthenticated shell.
  static List<RouteBase> authFlowRoutes() {
    return <RouteBase>[
      GoRoute(
        path: IamRoutes.loginPath,
        name: IamRoutes.loginName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: IamRoutes.registerPath,
        name: IamRoutes.registerName,
        builder: (context, state) => const RegistrationView(),
      ),
    ];
  }
}
