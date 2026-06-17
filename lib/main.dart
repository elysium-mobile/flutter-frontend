import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'iam/application/bloc/session_bloc.dart';
import 'service_locator.dart';
import 'shared/data/network/environment_config.dart';
import 'shared/presentation/design/app_theme.dart';

/// Application entry point — the absolute initialization layer.
///
/// Bootstraps the Flutter binding, initializes Firebase (skipped in the mock
/// flavor), resolves the flavor-aware service locator, builds the dual-router
/// from the long-lived [SessionBloc], and runs the app shell.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.ensureFontsLoaded();
  await _initializeFirebase();

  await ServiceLocator.init();

  final sessionBloc = GetIt.instance<SessionBloc>();
  final router = AppRouter.create(sessionBloc);

  runApp(SoftWorkApp(router: router, sessionBloc: sessionBloc));
}

/// Initializes Firebase from the centralized [EnvironmentConfig].
///
/// When a complete set of Firebase overrides is supplied at build time, explicit
/// [FirebaseOptions] are constructed from them; otherwise the platform's native
/// configuration is used.
///
/// Initialization is non-fatal: if Firebase is configured neither via build-time
/// defines nor via the native platform resources, the failure is logged and the
/// app still boots (to the unauthenticated shell). Firebase-backed operations
/// will then fail at call time rather than preventing startup, which keeps
/// Firebase-less development pipelines runnable.
Future<void> _initializeFirebase() async {
  // The Local/Develop mock flavor is fully offline; Firebase is not required.
  if (EnvironmentConfig.isMockMode) {
    return;
  }
  try {
    if (!EnvironmentConfig.hasFirebaseConfiguration) {
      await Firebase.initializeApp();
      return;
    }
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: EnvironmentConfig.firebaseApiKey,
        appId: EnvironmentConfig.firebaseAppId,
        messagingSenderId: EnvironmentConfig.firebaseMessagingSenderId,
        projectId: EnvironmentConfig.firebaseProjectId,
        storageBucket: EnvironmentConfig.firebaseStorageBucket.isEmpty
            ? null
            : EnvironmentConfig.firebaseStorageBucket,
      ),
    );
  } catch (error, stackTrace) {
    developer.log(
      'Firebase initialization failed; continuing without Firebase. '
      'Provide native config (google-services.json / GoogleService-Info.plist) '
      'or the FIREBASE_* --dart-define values to enable it.',
      name: 'bootstrap',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Root application widget composing the global session scope, router and theme.
class SoftWorkApp extends StatelessWidget {
  /// Creates the [SoftWorkApp].
  const SoftWorkApp({
    super.key,
    required this.router,
    required this.sessionBloc,
  });

  /// The configured dual-strategy router.
  final GoRouter router;

  /// The long-lived global session bloc, provided to the whole widget tree.
  final SessionBloc sessionBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>.value(
      value: sessionBloc,
      child: MaterialApp.router(
        title: 'SoftWork',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    );
  }
}
