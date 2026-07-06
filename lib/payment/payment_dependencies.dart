import 'package:get_it/get_it.dart';

import '../iam/domain/stores/authentication_store.dart';
import '../shared/data/local/app_database.dart';
import '../shared/data/network/api_client.dart';
import 'application/bloc/add_card_bloc.dart';
import 'application/bloc/membership_gate_bloc.dart';
import 'application/bloc/payment_methods_bloc.dart';
import 'application/bloc/plan_selection_bloc.dart';
import 'data/network/payment_web_service.dart';
import 'data/repositories/payment_repository_impl.dart';
import 'domain/repositories/payment_repository.dart';

/// Composition root of the payment bounded context.
///
/// Wires the feature's object graph into [GetIt], respecting the hexagonal
/// dependency direction: BLoCs depend only on the [PaymentRepository] port,
/// whose concrete adapter bridges the shared [ApiClient] and the Drift
/// [AppDatabase].
///
/// The web service and repository are lazy singletons (shared infrastructure).
/// The [MembershipGateBloc] is a long-lived lazy singleton (it feeds the router
/// guards, mirroring [SessionBloc]); the screen BLoCs are factories so each
/// `BlocProvider` boundary receives a fresh, disposable instance.
abstract final class PaymentDependencies {
  /// Registers the payment web service, repository and BLoCs into [sl].
  ///
  /// Must run after the shared dependencies (which provide [ApiClient] and
  /// [AppDatabase]); the [AuthenticationStore] the gate consumes is resolved
  /// lazily, so its registration order is irrelevant.
  static void register(GetIt sl) {
    sl
      ..registerLazySingleton<PaymentWebService>(
        () => PaymentWebService(sl<ApiClient>()),
      )
      ..registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(
          webService: sl<PaymentWebService>(),
          database: sl<AppDatabase>(),
        ),
      )
      ..registerLazySingleton<MembershipGateBloc>(
        () => MembershipGateBloc(
          repository: sl<PaymentRepository>(),
          authenticationStore: sl<AuthenticationStore>(),
        ),
      )
      ..registerFactory<PlanSelectionBloc>(
        () => PlanSelectionBloc(repository: sl<PaymentRepository>()),
      )
      ..registerFactory<PaymentMethodsBloc>(
        () => PaymentMethodsBloc(repository: sl<PaymentRepository>()),
      )
      ..registerFactory<AddCardBloc>(
        () => AddCardBloc(repository: sl<PaymentRepository>()),
      );
  }
}
