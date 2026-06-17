import 'dart:async';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/user.dart';
import '../../domain/stores/authentication_store.dart';

/// In-memory mock adapter implementing the [AuthenticationStore] port for the
/// Local/Develop flavor.
///
/// It honors the authentic domain contract while depending on nothing external:
/// no network client, no Firebase, no Google Sign-In, no platform bindings.
/// Every operation resolves to a pre-baked [AuthSession] after a short simulated
/// latency, enabling the full authenticated experience to be exercised offline.
class MockAuthenticationStore implements AuthenticationStore {
  /// Simulated round-trip latency applied to each operation.
  static const Duration _latency = Duration(milliseconds: 400);

  final StreamController<AuthSession?> _sessionController =
      StreamController<AuthSession?>.broadcast();

  AuthSession? _currentSession;

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
  }) async {
    await Future<void>.delayed(_latency);
    return _establish(_buildSession(email: email));
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    await Future<void>.delayed(_latency);
    return _establish(
      _buildSession(
        username: 'Google Employee',
        email: 'google.employee@softwork.com',
      ),
    );
  }

  @override
  Future<AuthSession> registerWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(_latency);
    return _establish(_buildSession(username: username, email: email));
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(_latency);
    _publish(null);
  }

  @override
  Future<void> dispose() async {
    await _sessionController.close();
  }

  /// Builds a deterministic mock [AuthSession] for the supplied identity.
  AuthSession _buildSession({String? username, String? email}) {
    final resolvedEmail = email ?? 'employee@softwork.com';
    return AuthSession(
      user: User(
        id: const Id('mock-user-0001'),
        username: username ?? _deriveUsername(resolvedEmail),
        email: resolvedEmail,
      ),
      accessToken: 'mock-access-token',
      refreshToken: 'mock-refresh-token',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  /// Derives a readable username from an email local part.
  String _deriveUsername(String email) {
    final localPart = email.split('@').first;
    if (localPart.isEmpty) return 'Mock Employee';
    return localPart[0].toUpperCase() + localPart.substring(1);
  }

  /// Caches the session and notifies subscribers.
  AuthSession _establish(AuthSession session) {
    _publish(session);
    return session;
  }

  void _publish(AuthSession? session) {
    _currentSession = session;
    if (!_sessionController.isClosed) {
      _sessionController.add(session);
    }
  }
}
