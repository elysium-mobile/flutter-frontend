import '../models/auth_session.dart';

/// Port (hexagonal) describing the identity and access management capabilities
/// required by the application layer.
///
/// Expressed purely in terms of domain types and primitives; it is agnostic of
/// the underlying providers (Firebase, Google Sign-In, REST). Concrete adapters
/// live in `data/stores/`.
///
/// Operations communicate failure by throwing an [Exception]; the application
/// layer catches it once and maps it to a renderable error state. No typed
/// failure hierarchy is exposed, keeping the surface intentionally small.
abstract interface class AuthenticationStore {
  /// Emits the current [AuthSession] whenever it changes, and `null` whenever
  /// the user becomes unauthenticated (initial state or after [signOut]).
  Stream<AuthSession?> sessionChanges();

  /// The session currently held in memory, or `null` when unauthenticated.
  AuthSession? get currentSession;

  /// Authenticates an employee using their institutional [email]/[password].
  ///
  /// Returns the established [AuthSession]; throws on failure.
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  /// Authenticates an employee through the Google single sign-on flow, bridging
  /// the Google credential into the production identity provider.
  ///
  /// Throws when the user dismisses the native flow or authentication fails.
  Future<AuthSession> signInWithGoogle();

  /// Registers a brand new employee account and immediately establishes an
  /// [AuthSession] for it.
  ///
  /// Throws on failure (e.g. the email is already in use).
  Future<AuthSession> registerWithEmail({
    required String username,
    required String email,
    required String password,
  });

  /// Terminates the active session across every identity provider and emits
  /// `null` on [sessionChanges].
  Future<void> signOut();

  /// Releases any resources held by the implementation.
  Future<void> dispose();
}
