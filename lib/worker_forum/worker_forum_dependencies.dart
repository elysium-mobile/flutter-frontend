import 'package:get_it/get_it.dart';

import '../iam/domain/stores/authentication_store.dart';
import '../shared/data/network/api_client.dart';
import 'application/bloc/forum_bloc.dart';
import 'data/network/forum_web_service.dart';
import 'data/repositories/forum_repository_impl.dart';
import 'domain/repositories/forum_repository.dart';

/// Composition root of the Worker Forum (RRHH read-only) bounded context.
///
/// Wires the feature's object graph into [GetIt], respecting the hexagonal
/// dependency direction: the BLoC depends only on the [ForumRepository] port,
/// whose adapter bridges the shared [ApiClient]. The current-account resolver is
/// supplied here as a closure over the [AuthenticationStore] port, so the forum
/// adapter stays decoupled from the IAM context while still scoping data to the
/// caller's company.
abstract final class WorkerForumDependencies {
  /// Registers the forum web service, repository and BLoC into [sl].
  ///
  /// Must run after the shared dependencies (which provide [ApiClient]); the
  /// account resolver reads [AuthenticationStore] lazily at call time, so its
  /// registration order relative to the auth store is immaterial.
  static void register(GetIt sl) {
    sl
      ..registerLazySingleton<ForumWebService>(
        () => ForumWebService(sl<ApiClient>()),
      )
      ..registerLazySingleton<ForumRepository>(
        () => ForumRepositoryImpl(
          webService: sl<ForumWebService>(),
          accountIdProvider: () {
            final session = sl<AuthenticationStore>().currentSession;
            if (session == null) return null;
            return int.tryParse(session.user.id.value);
          },
        ),
      )
      ..registerFactory<ForumBloc>(
        () => ForumBloc(repository: sl<ForumRepository>()),
      );
  }
}
