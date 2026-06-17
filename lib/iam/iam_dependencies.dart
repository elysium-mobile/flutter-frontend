import 'package:get_it/get_it.dart';

import '../shared/data/network/api_client.dart';
import 'application/bloc/login_bloc.dart';
import 'application/bloc/registration_bloc.dart';
import 'application/bloc/session_bloc.dart';
import 'data/network/iam_web_service.dart';
import 'domain/stores/authentication_store.dart';

/// Composition root of the IAM bounded context.
///
/// Wires the feature's object graph into [GetIt], respecting the hexagonal
/// dependency direction: blocs depend only on the [AuthenticationStore] port.
///
/// The concrete [AuthenticationStore] adapter (live vs. mock) is selected by the
/// flavor-aware service locator and must be registered separately; this method
/// only registers the web service and the dependent blocs.
///
/// The web service is a lazy singleton (shared infrastructure); the session
/// machine is a lazy singleton (long-lived), while the login/registration blocs
/// are factories so each [BlocProvider] boundary receives a fresh,
/// independently-disposable instance and the locator never holds UI state.
abstract final class IamDependencies {
  /// Registers the IAM web service and blocs into [sl].
  ///
  /// Must run after the shared dependencies (which provide [ApiClient]) and
  /// after an [AuthenticationStore] has been registered by the service locator.
  static void register(GetIt sl) {
    sl
      ..registerLazySingleton<IamWebService>(
        () => IamWebService(sl<ApiClient>()),
      )
      // Long-lived session machine: the reactive source for the router guards.
      ..registerLazySingleton<SessionBloc>(
        () => SessionBloc(authenticationStore: sl<AuthenticationStore>()),
      )
      ..registerFactory<LoginBloc>(
        () => LoginBloc(authenticationStore: sl<AuthenticationStore>()),
      )
      ..registerFactory<RegistrationBloc>(
        () => RegistrationBloc(authenticationStore: sl<AuthenticationStore>()),
      );
  }
}
