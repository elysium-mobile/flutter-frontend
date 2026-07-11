import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../application/bloc/dashboard_assistant_bloc.dart';
import '../views/hr_ai_assistant_view.dart';
import 'dashboard_routes.dart';

/// Assembles the authenticated, full-screen routes owned by the Dashboard
/// bounded context (outside the persistent bottom-navigation shell).
///
/// Mirrors the payment context's router composition: the root `app_router.dart`
/// spreads [authenticatedRoutes] into its authenticated branch, keeping the
/// feature's navigation wiring encapsulated here.
abstract final class DashboardRouter {
  /// Returns the dashboard's authenticated full-screen routes.
  ///
  /// The AI Climate Assistant is provided a fresh [DashboardAssistantBloc]
  /// (a GetIt factory) that immediately loads the selectable companies.
  static List<RouteBase> authenticatedRoutes() {
    return <RouteBase>[
      GoRoute(
        path: DashboardRoutes.aiAssistantPath,
        name: DashboardRoutes.aiAssistantName,
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<DashboardAssistantBloc>(
          create: (_) => GetIt.instance<DashboardAssistantBloc>()
            ..add(const DashboardAssistantStarted()),
          child: const HrAiAssistantView(),
        ),
      ),
    ];
  }
}
