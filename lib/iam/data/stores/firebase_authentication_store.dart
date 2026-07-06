import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../shared/data/local/app_database.dart';
import '../../../shared/data/network/api_client.dart';
import '../../../shared/data/network/environment_config.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/stores/authentication_store.dart';
import '../models/db_mapping_extensions.dart';
import '../network/iam_web_service.dart';
import '../network/requests/register_request.dart';
import '../network/requests/sign_in_request.dart';

/// Concrete adapter implementing [AuthenticationStore] on top of Firebase
/// Authentication, Google Sign-In and the backend (via [IamWebService]).
///
/// Identity vs. profile: Firebase/Google act as the verified *identity*
/// provider; the resulting ID token is bridged to the backend, which is the
/// authoritative source for the first-party [AuthSession]. On success the access
/// token is persisted into the local [AppDatabase] (Drift/sqlite3) so the shared
/// [ApiClient] can authorize subsequent requests across cold starts.
///
/// Provider-specific errors are caught and re-thrown as plain [Exception]s with
/// English diagnostic messages; the application layer maps them to a generic
/// user-facing message.
class FirebaseAuthenticationStore implements AuthenticationStore {
  /// Creates a [FirebaseAuthenticationStore] wired to live production services.
  ///
  /// [webService] performs the backend credential exchange, [database] persists
  /// the established session, and [firebaseAuth]/[googleSignIn] default to the
  /// live platform singletons.
  FirebaseAuthenticationStore({
    required IamWebService webService,
    required AppDatabase database,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _webService = webService, // ignore: prefer_initializing_formals
        _database = database, // ignore: prefer_initializing_formals
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final IamWebService _webService;
  final AppDatabase _database;
  final FirebaseAuth _firebaseAuth;
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
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final idToken = await _requireIdToken(credential.user);
      final response =
          await _webService.authenticate(SignInRequest(idToken: idToken));
      return _establish(response.toDomain());
    });
  }

  @override
  Future<AuthSession> signInWithGoogle() {
    return _guard(() async {
      await _ensureGoogleInitialized();

      final GoogleSignInAccount account;
      try {
        account = await _googleSignIn.authenticate(
          scopeHint: const <String>['email', 'profile'],
        );
      } on GoogleSignInException catch (error) {
        if (error.code == GoogleSignInExceptionCode.canceled) {
          throw Exception('Google sign-in was cancelled.');
        }
        rethrow;
      }

      final googleAuth = account.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final idToken = await _requireIdToken(userCredential.user);
      final response =
          await _webService.authenticate(SignInRequest(idToken: idToken));
      return _establish(response.toDomain());
    });
  }

  @override
  Future<AuthSession> registerWithEmail({
    required String username,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(username);

      final idToken = await _requireIdToken(credential.user);
      final response = await _webService.register(
        RegisterRequest(idToken: idToken, username: username, email: email),
      );
      return _establish(response.toDomain());
    });
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
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

  /// Lazily initializes Google Sign-In exactly once per process.
  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    final serverClientId = EnvironmentConfig.googleServerClientId;
    await _googleSignIn.initialize(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );
    _googleInitialized = true;
  }

  /// Extracts a fresh Firebase ID token, asserting an authenticated user.
  Future<String> _requireIdToken(User? user) async {
    if (user == null) {
      throw Exception('Authentication succeeded but no user was returned.');
    }
    final token = await user.getIdToken();
    if (token == null || token.isEmpty) {
      throw Exception('Unable to obtain a Firebase ID token.');
    }
    return token;
  }

  /// Runs [action], normalizing provider/transport errors into [Exception].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw Exception(error.message ?? 'Authentication failed.');
    } on ApiException catch (error) {
      throw Exception(error.message ?? 'Authentication request failed.');
    }
  }
}
