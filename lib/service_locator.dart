import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dashboard/dashboard_dependencies.dart';
import 'payment/payment_dependencies.dart';
import 'iam/data/network/iam_web_service.dart';
import 'iam/data/stores/firebase_authentication_store.dart';
import 'iam/domain/stores/authentication_store.dart';
import 'iam/iam_dependencies.dart';
import 'shared/data/local/app_database.dart';
import 'shared/data/pref/shared_preferences_adapter.dart';
import 'shared/shared_dependencies.dart';

/// Application-wide service locator and production composition root.
///
/// Registers the definitive object graph wired exclusively to live
/// infrastructure — the Drift/sqlite3 [AppDatabase], the centralized network
/// client, and the [FirebaseAuthenticationStore] adapter. There is no flavor
/// branching: every dependency resolves to its concrete production
/// implementation.
abstract final class ServiceLocator {
  /// Initializes the global locator graph.
  ///
  /// Must be awaited once during bootstrap, before any dependency is resolved.
  static Future<void> init({GetIt? locator}) async {
    final sl = locator ?? GetIt.instance;

    // Local relational cache (Drift over native sqlite3).
    sl.registerLazySingleton<AppDatabase>(AppDatabase.new);

    // Shared cross-cutting infrastructure (key-value cache + ApiClient).
    final preferences = await SharedPreferencesAdapter.create();
    SharedDependencies.register(sl, preferences);

    // IAM web service and blocs (depend only on the AuthenticationStore port).
    IamDependencies.register(sl);

    // Dashboard (HR Analytics) web service, repository and bloc.
    DashboardDependencies.register(sl);

    // Payment (subscriptions & cards) web service, repository and blocs.
    PaymentDependencies.register(sl);

    // Production authentication adapter.
    _registerAuthenticationStore(sl);
  }

  /// Registers the sole production [AuthenticationStore] implementation.
  ///
  /// The factory injects the live [FirebaseAuth.instance] and
  /// [GoogleSignIn.instance] singletons alongside the resolved [AppDatabase]
  /// (for session persistence) and [IamWebService] (for the backend credential
  /// exchange).
  static void _registerAuthenticationStore(GetIt sl) {
    sl.registerLazySingleton<AuthenticationStore>(
      () => FirebaseAuthenticationStore(
        webService: sl<IamWebService>(),
        database: sl<AppDatabase>(),
        firebaseAuth: FirebaseAuth.instance,
        googleSignIn: GoogleSignIn.instance,
      ),
    );
  }
}
