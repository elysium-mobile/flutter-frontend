import 'package:get_it/get_it.dart';

import '../shared/data/local/app_database.dart';
import '../shared/data/network/api_client.dart';
import 'application/bloc/dashboard_assistant_bloc.dart';
import 'application/bloc/hr_reports_bloc.dart';
import 'data/network/dashboard_web_service.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'domain/repositories/dashboard_repository.dart';

/// Composition root of the Dashboard (HR Analytics) bounded context.
///
/// Wires the feature's object graph into [GetIt], respecting the hexagonal
/// dependency direction: the BLoC depends only on the [DashboardRepository]
/// port, whose concrete adapter bridges the shared [ApiClient] and the Drift
/// [AppDatabase].
///
/// The web service and repository are lazy singletons (shared infrastructure);
/// the [HrReportsBloc] is a factory so each `BlocProvider` boundary receives a
/// fresh, independently-disposable instance and the locator never holds UI
/// state.
abstract final class DashboardDependencies {
  /// Registers the dashboard web service, repository and BLoC into [sl].
  ///
  /// Must run after the shared dependencies (which provide [ApiClient] and
  /// [AppDatabase]).
  static void register(GetIt sl) {
    sl
      ..registerLazySingleton<DashboardWebService>(
        () => DashboardWebService(sl<ApiClient>()),
      )
      ..registerLazySingleton<DashboardRepository>(
        () => DashboardRepositoryImpl(
          webService: sl<DashboardWebService>(),
          database: sl<AppDatabase>(),
        ),
      )
      ..registerFactory<HrReportsBloc>(
        () => HrReportsBloc(repository: sl<DashboardRepository>()),
      )
      ..registerFactory<DashboardAssistantBloc>(
        () => DashboardAssistantBloc(repository: sl<DashboardRepository>()),
      );
  }
}
