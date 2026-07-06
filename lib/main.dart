import 'dart:developer' as developer;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'firebase_options.dart';
import 'iam/application/bloc/session_bloc.dart';
import 'payment/application/bloc/membership_gate_bloc.dart';
import 'service_locator.dart';
import 'shared/application/bloc/locale_bloc.dart';
import 'shared/data/network/environment_config.dart';
import 'shared/domain/models/app_language.dart';
import 'shared/presentation/design/app_theme.dart';
import 'shared/presentation/i18n/app_locale.dart';

/// Application entry point — the absolute initialization layer.
///
/// Bootstraps the Flutter binding, initializes Firebase, resolves the
/// production service locator, builds the dual-router from the long-lived
/// [SessionBloc], and runs the app shell.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppTheme.ensureFontsLoaded();
  await _initializeFirebase();

  await ServiceLocator.init();

  final sessionBloc = GetIt.instance<SessionBloc>();
  final membershipGateBloc = GetIt.instance<MembershipGateBloc>();
  // Hydrate the persisted language preference before the first frame so the app
  // opens directly in the user's chosen language (no flash of the default).
  final localeBloc = GetIt.instance<LocaleBloc>()..add(const LocaleInitialized());
  final router = AppRouter.create(sessionBloc, membershipGateBloc);

  runApp(SoftWorkApp(
    router: router,
    sessionBloc: sessionBloc,
    membershipGateBloc: membershipGateBloc,
    localeBloc: localeBloc,
  ));
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
  try {
    if (!EnvironmentConfig.hasFirebaseConfiguration) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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
    required this.membershipGateBloc,
    required this.localeBloc,
  });

  /// The configured dual-strategy router.
  final GoRouter router;

  /// The long-lived global session bloc, provided to the whole widget tree.
  final SessionBloc sessionBloc;

  /// The long-lived membership gate bloc feeding the router's renewal guard and
  /// consumed by the plan-selection success flow.
  final MembershipGateBloc membershipGateBloc;

  /// The long-lived localization bloc driving the reactive interface language.
  final LocaleBloc localeBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<SessionBloc>.value(value: sessionBloc),
        BlocProvider<MembershipGateBloc>.value(value: membershipGateBloc),
        BlocProvider<LocaleBloc>.value(value: localeBloc),
      ],
      // Reactive localization boundary: only the active language is selected, so
      // the `MaterialApp` (and the `Localizations` subtree beneath it) rebuilds
      // exclusively on a language switch — never on unrelated app state.
      child: BlocSelector<LocaleBloc, LocaleState, AppLanguage>(
        selector: (LocaleState state) => state.language,
        builder: (BuildContext context, AppLanguage language) {
          // Mirror the selected language into the process-wide holder that the
          // static [AppStrings] getters read, immediately before the
          // `Localizations` subtree below rebuilds and re-resolves every string.
          AppLocale.current = language;
          return MaterialApp.router(
            title: 'SoftWork',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: AppTheme.light(),
            locale: Locale(language.code),
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const <Locale>[
              Locale('es'),
              Locale('en'),
            ],
          );
        },
      ),
    );
  }
}
