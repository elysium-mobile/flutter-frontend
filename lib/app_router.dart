import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'iam/application/bloc/session_bloc.dart';
import 'iam/presentation/navigation/iam_router.dart';
import 'iam/presentation/navigation/iam_routes.dart';
import 'iam/presentation/views/profile_config_view.dart';
import 'iam/presentation/views/profile_view.dart';
import 'iam/presentation/views/session_started_view.dart';
import 'iam/presentation/views/user_registered_view.dart';
import 'shared/presentation/views/alerts_view.dart';
import 'shared/presentation/views/home_shell_view.dart';
import 'shared/presentation/views/main_menu_view.dart';
import 'shared/presentation/views/reports_view.dart';

/// Route catalogue owned by the authenticated shell (shared destinations).
///
/// The profile destinations are owned by [IamRoutes]; the remaining shell tabs
/// are declared here as they belong to the shared cross-cutting context.
abstract final class AppRoutes {
  /// Path of the Menu (dashboard) tab.
  static const String menuPath = '/menu';

  /// Symbolic name of the Menu tab.
  static const String menuName = 'menu';

  /// Path of the Alerts tab.
  static const String alertsPath = '/alerts';

  /// Symbolic name of the Alerts tab.
  static const String alertsName = 'alerts';

  /// Path of the Reports tab.
  static const String reportsPath = '/reports';

  /// Symbolic name of the Reports tab.
  static const String reportsName = 'reports';
}

/// Builds the application [GoRouter] implementing the dual-router strategy.
///
/// A single top-level [GoRouter.redirect] reacts to the [SessionBloc] state and
/// switches between two shells:
///
/// * Unauthenticated shell — login and registration flows.
/// * Authenticated shell — a persistent bottom-navigation container with the
///   Menu, Profile, Alerts and Reports destinations, plus the full-screen
///   profile configuration route.
///
/// The router is rebuilt-on-change via [GoRouterRefreshStream], wired to the
/// bloc's state stream so authentication transitions immediately re-evaluate the
/// active shell.
abstract final class AppRouter {
  /// Creates the configured [GoRouter] bound to [sessionBloc].
  static GoRouter create(SessionBloc sessionBloc) {
    return GoRouter(
      initialLocation: IamRoutes.loginPath,
      refreshListenable: GoRouterRefreshStream(sessionBloc.stream),
      redirect: (context, state) => _redirect(sessionBloc, state),
      routes: <RouteBase>[
        // --- Unauthenticated shell --------------------------------------------
        ...IamRouter.authFlowRoutes(),
        GoRoute(
          path: IamRoutes.sessionStartedPath,
          name: IamRoutes.sessionStartedName,
          builder: (context, state) => SessionStartedView(
            onContinue: () => context.goNamed(AppRoutes.menuName),
          ),
        ),
        GoRoute(
          path: IamRoutes.userRegisteredPath,
          name: IamRoutes.userRegisteredName,
          builder: (context, state) => UserRegisteredView(
            onSignIn: () => context.goNamed(AppRoutes.menuName),
          ),
        ),

        // --- Authenticated shell: persistent bottom navigation ----------------
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              HomeShellView(navigationShell: navigationShell),
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.menuPath,
                  name: AppRoutes.menuName,
                  builder: (context, state) => const MainMenuView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: IamRoutes.profilePath,
                  name: IamRoutes.profileName,
                  builder: (context, state) => const ProfileView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.alertsPath,
                  name: AppRoutes.alertsName,
                  builder: (context, state) => const AlertsView(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: AppRoutes.reportsPath,
                  name: AppRoutes.reportsName,
                  builder: (context, state) => const ReportsView(),
                ),
              ],
            ),
          ],
        ),

        // --- Authenticated full-screen route (outside the bottom bar) ---------
        GoRoute(
          path: IamRoutes.profileEditPath,
          name: IamRoutes.profileEditName,
          builder: (context, state) => const ProfileConfigView(),
        ),
      ],
    );
  }

  /// Reactive redirection guard implementing the dual-shell switch.
  static String? _redirect(SessionBloc sessionBloc, GoRouterState state) {
    final bool isAuthenticated = sessionBloc.state.isAuthenticated;
    final String location = state.matchedLocation;

    final bool isAuthFlow = location == IamRoutes.loginPath ||
        location == IamRoutes.registerPath;
    final bool isNeutral = location == IamRoutes.sessionStartedPath ||
        location == IamRoutes.userRegisteredPath;

    if (!isAuthenticated) {
      // Unauthenticated users may only see the auth flow or success screens.
      return (isAuthFlow || isNeutral) ? null : IamRoutes.loginPath;
    }

    // Authenticated users are bounced out of the login/registration screens.
    return isAuthFlow ? AppRoutes.menuPath : null;
  }
}

/// Bridges a [Stream] to a [Listenable] so [GoRouter.refreshListenable] can
/// re-evaluate redirects whenever the session state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Creates a [GoRouterRefreshStream] listening to [stream].
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream
        .asBroadcastStream()
        .listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
