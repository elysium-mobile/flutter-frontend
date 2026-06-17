import 'package:get_it/get_it.dart';

import 'iam/data/network/iam_web_service.dart';
import 'iam/data/stores/firebase_authentication_store.dart';
import 'iam/data/stores/mock_authentication_store.dart';
import 'iam/domain/stores/authentication_store.dart';
import 'iam/iam_dependencies.dart';
import 'shared/data/network/environment_config.dart';
import 'shared/data/pref/shared_preferences_adapter.dart';
import 'shared/shared_dependencies.dart';

/// Application-wide service locator and flavor-aware composition root.
///
/// Resolves the global [GetIt] graph and applies the Environment-Driven Mock
/// Flavor strategy: it queries [EnvironmentConfig.isMockMode] to bind the
/// appropriate concrete [AuthenticationStore] adapter — a fully offline
/// [MockAuthenticationStore] for the Local/Develop flavor, or the live
/// [FirebaseAuthenticationStore] for Production — while every other dependency
/// is registered uniformly across flavors.
abstract final class ServiceLocator {
  /// Initializes the global locator graph.
  ///
  /// Must be awaited once during bootstrap, before any dependency is resolved.
  static Future<void> init({GetIt? locator}) async {
    final sl = locator ?? GetIt.instance;

    // Shared cross-cutting infrastructure (cache + centralized network client).
    final preferences = await SharedPreferencesAdapter.create();
    SharedDependencies.register(sl, preferences);

    // Flavor-polymorphic domain port: the only registration that diverges.
    _registerAuthenticationStore(sl);

    // IAM web service and blocs (flavor-agnostic; depend only on the port).
    IamDependencies.register(sl);
  }

  /// Binds the concrete [AuthenticationStore] selected by the active flavor.
  static void _registerAuthenticationStore(GetIt sl) {
    if (EnvironmentConfig.isMockMode) {
      sl.registerLazySingleton<AuthenticationStore>(
        MockAuthenticationStore.new,
      );
      return;
    }
    sl.registerLazySingleton<AuthenticationStore>(
      () => FirebaseAuthenticationStore(
        webService: sl<IamWebService>(),
        preferences: sl<SharedPreferencesAdapter>(),
      ),
    );
  }
}
