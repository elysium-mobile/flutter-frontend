import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import '../../../shared/data/local/app_database.dart';
import '../../../shared/data/network/api_client.dart';
import '../../../shared/data/network/environment_config.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/google_auth_result.dart';
import '../../domain/models/rrhh_profile_draft.dart';
import '../../domain/stores/authentication_store.dart';
import '../models/db_mapping_extensions.dart';
import '../network/iam_web_service.dart';
import '../network/requests/google_rrhh_sign_up_request.dart';
import '../network/requests/google_sign_in_request.dart';
import '../network/requests/rrhh_profile_sign_up_request.dart';
import '../network/requests/sign_in_request.dart';

/// Concrete [AuthenticationStore] adapter backed exclusively by the ELYSIUM API
/// and Google Sign-In — no Firebase.
///
/// Email/password credentials are exchanged for a JWT at
/// `/authentication/sign-in`; Google authentication obtains a Google `id_token`
/// (audience = `GOOGLE_OAUTH_CLIENT`) and validates it at `/authentication/google`,
/// completing RRHH sign-up at `/authentication/sign-up/rrhh/google` when the
/// account does not exist yet. On success the JWT is persisted into the local
/// [AppDatabase] (Drift/sqlite3) so the shared [ApiClient] can authorize
/// subsequent requests across cold starts.
///
/// Provider/transport errors are caught and re-thrown as plain [Exception]s with
/// English diagnostic messages; the application layer maps them to a generic
/// user-facing message.
class ElysiumAuthenticationStore implements AuthenticationStore {
  /// Creates an [ElysiumAuthenticationStore] wired to live production services.
  ElysiumAuthenticationStore({
    required IamWebService webService,
    required AppDatabase database,
    GoogleSignIn? googleSignIn,
  })  : _webService = webService, // ignore: prefer_initializing_formals
        _database = database, // ignore: prefer_initializing_formals
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final IamWebService _webService;
  final AppDatabase _database;
  final GoogleSignIn _googleSignIn;

  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _currentSession;
  bool _googleInitialized = false;

  @override
  AuthSession? get currentSession => _currentSession;

  @override
  Stream<AuthSession?> sessionChanges() async* {
    yield _currentSession;
    yield* _sessionController.stream;
  }

  @override
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final response = await _webService.signIn(
        SignInRequest(email: email, password: password),
      );
      return _establish(response.toDomain());
    });
  }

  @override
  Future<GoogleAuthResult> authenticateWithGoogle() {
    return _guard(() async {
      final account = await _obtainGoogleAccount();
      final String? idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Unable to obtain a Google ID token.');
      }

      final response = await _webService.googleAuthenticate(
        GoogleSignInRequest(idToken: idToken),
      );
      if (response.registered) {
        return GoogleAuthenticated(await _establish(response.toSession()));
      }
      return GoogleRegistrationRequired(idToken: idToken, email: account.email);
    });
  }

  @override
  Future<AuthSession> signUpRrhh({
    required RrhhProfileDraft draft,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      // Classic RRHH sign-up returns the created profile (no token); the JWT
      // session is then obtained via the standard email/password sign-in.
      await _webService.signUpRrhh(
        RrhhProfileSignUpRequest.fromDraft(
          draft: draft,
          email: email,
          password: password,
        ),
      );
      final response = await _webService.signIn(
        SignInRequest(email: email, password: password),
      );
      return _establish(response.toDomain());
    });
  }

  @override
  Future<AuthSession> completeGoogleRrhhSignUp({
    required String idToken,
    required RrhhProfileDraft draft,
  }) {
    return _guard(() async {
      final response = await _webService.signUpRrhhGoogle(
        GoogleRrhhSignUpRequest.fromDraft(idToken: idToken, draft: draft),
      );
      return _establish(response.toDomain());
    });
  }

  @override
  Future<void> signOut() async {
    // Best-effort Google sign-out: never let a provider hiccup block the local
    // session teardown that actually unauthenticates the app.
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignored — the authoritative sign-out is clearing the local session.
    }
    await _database.clearCachedSessions();
    _publish(null);
  }

  @override
  Future<void> dispose() async {
    await _sessionController.close();
  }

  /// Persists the session row, caches the session in memory and notifies
  /// subscribers.
  Future<AuthSession> _establish(AuthSession session) async {
    await _database.cacheSession(session.toCompanion());
    _publish(session);
    return session;
  }

  /// Updates the in-memory session and emits it on [sessionChanges].
  void _publish(AuthSession? session) {
    _currentSession = session;
    if (!_sessionController.isClosed) {
      _sessionController.add(session);
    }
  }

  /// Runs the native Google Sign-In flow, translating a user cancellation into a
  /// clear [Exception].
  Future<GoogleSignInAccount> _obtainGoogleAccount() async {
    await _ensureGoogleInitialized();
    try {
      return await _googleSignIn.authenticate(
        scopeHint: const <String>['email', 'profile'],
      );
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('Google sign-in was cancelled.');
      }
      throw Exception(error.description ?? 'Google sign-in failed.');
    }
  }

  /// Lazily initializes Google Sign-In exactly once per process, binding the
  /// `GOOGLE_OAUTH_CLIENT` as the `serverClientId` so the issued `id_token`
  /// carries the audience the backend expects.
  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    final String serverClientId = EnvironmentConfig.googleServerClientId;
    await _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _googleInitialized = true;
  }

  /// Runs [action], normalizing transport/provider errors into [Exception].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ApiException catch (error) {
      throw Exception(error.message ?? 'Authentication request failed.');
    }
  }
}
