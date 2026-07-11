import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../application/bloc/forum_bloc.dart';
import '../../domain/models/forum_thread.dart';
import '../views/forum_thread_detail_view.dart';
import '../views/forum_thread_list_view.dart';
import 'forum_routes.dart';

/// Assembles the authenticated, full-screen routes owned by the Worker Forum
/// bounded context (outside the persistent bottom-navigation shell).
///
/// Mirrors the payment/dashboard router composition: the root `app_router.dart`
/// spreads [authenticatedRoutes] into its authenticated branch.
abstract final class ForumRouter {
  /// Returns the forum's authenticated full-screen routes.
  static List<RouteBase> authenticatedRoutes() {
    return <RouteBase>[
      GoRoute(
        path: ForumRoutes.forumPath,
        name: ForumRoutes.forumName,
        builder: (BuildContext context, GoRouterState state) =>
            BlocProvider<ForumBloc>(
          create: (_) =>
              GetIt.instance<ForumBloc>()..add(const ForumStarted()),
          child: const ForumThreadListView(),
        ),
      ),
      GoRoute(
        path: ForumRoutes.threadPath,
        name: ForumRoutes.threadName,
        // The selected thread (with its nested messages) is passed via in-memory
        // `extra`; a direct/deep-link hit without it bounces back to the list.
        redirect: (BuildContext context, GoRouterState state) =>
            state.extra is ForumThread ? null : ForumRoutes.forumPath,
        builder: (BuildContext context, GoRouterState state) =>
            ForumThreadDetailView(thread: state.extra as ForumThread),
      ),
    ];
  }
}
