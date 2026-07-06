import 'package:get_it/get_it.dart';

import 'application/bloc/locale_bloc.dart';
import 'data/local/app_database.dart';
import 'data/network/api_client.dart';
import 'data/pref/preferences_locale_store.dart';
import 'data/pref/shared_preferences_adapter.dart';
import 'domain/stores/locale_store.dart';

/// Composition root of the shared foundational layer.
///
/// Registers the cross-cutting infrastructure consumed by every bounded
/// context — the global key-value cache, the centralized [ApiClient], and the
/// long-lived [LocaleBloc] governing runtime localization. The client's bearer
/// token is sourced from the persisted session, wiring the cache and network
/// layers together without either depending on a feature.
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
          // Bearer token is sourced from the persisted Drift session row.
          tokenProvider: () async => sl<AppDatabase>().readAccessToken(),
        ),
      )
      // Localization: the persistence port and its long-lived bloc. The bloc is
      // a singleton (like SessionBloc) so the app has one source of truth for
      // the active language across the whole widget tree.
      ..registerLazySingleton<LocaleStore>(
        () => PreferencesLocaleStore(preferences),
      )
      ..registerLazySingleton<LocaleBloc>(
        () => LocaleBloc(localeStore: sl<LocaleStore>()),
      );
  }
}
