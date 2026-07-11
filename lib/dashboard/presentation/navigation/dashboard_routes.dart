/// Route catalogue owned by the Dashboard (HR Analytics) bounded context.
///
/// Declared in a dedicated module (mirroring the payment context) so both the
/// root router and the dashboard views can reference the symbolic names without
/// importing the root `app_router.dart`, avoiding an import cycle.
abstract final class DashboardRoutes {
  /// Path of the full-screen HR AI Climate Assistant.
  static const String aiAssistantPath = '/reports/ai-assistant';

  /// Symbolic name of the HR AI Climate Assistant route.
  static const String aiAssistantName = 'ai-assistant';
}
