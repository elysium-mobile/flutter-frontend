import 'package:get_it/get_it.dart';

import 'data/network/api_client.dart';
import 'data/pref/shared_preferences_adapter.dart';

/// Composition root of the shared foundational layer.
///
/// Registers the cross-cutting infrastructure consumed by every bounded
/// context — the global key-value cache and the centralized [ApiClient]. The
/// client's bearer token is sourced from the persisted session, wiring the cache
/// and network layers together without either depending on a feature.
abstract final class SharedDependencies {
  /// Registers shared dependencies into [sl].
  ///
  /// [preferences] must already be resolved (see
  /// [SharedPreferencesAdapter.create]) before this is called during bootstrap.
  static void register(GetIt sl, SharedPreferencesAdapter preferences) {
    sl
      ..registerSingleton<SharedPreferencesAdapter>(preferences)
      ..registerLazySingleton<ApiClient>(
        () => ApiClient(
          tokenProvider: () async =>
              sl<SharedPreferencesAdapter>().sessionToken,
        ),
      );
  }
}
