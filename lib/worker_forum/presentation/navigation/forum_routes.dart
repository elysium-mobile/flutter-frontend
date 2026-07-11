/// Route catalogue owned by the Worker Forum (RRHH read-only) bounded context.
///
/// Declared in a dedicated module (mirroring the payment/dashboard contexts) so
/// both the root router and the forum views can reference the symbolic names
/// without importing the root `app_router.dart`, avoiding an import cycle.
abstract final class ForumRoutes {
  /// Path of the forum thread-list screen.
  static const String forumPath = '/forum';

  /// Symbolic name of the forum thread-list route.
  static const String forumName = 'forum';

  /// Path of the forum thread-conversation screen.
  static const String threadPath = '/forum/thread';

  /// Symbolic name of the forum thread-conversation route.
  static const String threadName = 'forum-thread';
}
