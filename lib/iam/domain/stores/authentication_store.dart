import '../models/auth_session.dart';
import '../models/google_auth_result.dart';
import '../models/rrhh_profile_draft.dart';

/// Port (hexagonal) describing the identity and access management capabilities
/// required by the application layer.
///
/// Expressed purely in terms of domain types and primitives; it is agnostic of
/// the underlying providers (Google Sign-In, the ELYSIUM REST API). The concrete
/// adapter lives in `data/stores/`.
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

  /// Authenticates an RRHH user with their institutional [email]/[password]
  /// against `POST /authentication/sign-in`.
  ///
  /// Returns the established [AuthSession]; throws on failure.
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });

  /// Runs the first phase of Google authentication: obtains a Google `id_token`
  /// (audience = `GOOGLE_OAUTH_CLIENT`) and validates it via
  /// `POST /authentication/google`.
  ///
  /// Returns [GoogleAuthenticated] when the account already exists, or
  /// [GoogleRegistrationRequired] when the verified identity still needs to
  /// complete RRHH sign-up. Throws when the native flow is dismissed or the
  /// request fails.
  Future<GoogleAuthResult> authenticateWithGoogle();

  /// Registers a brand-new RRHH account via `POST /authentication/sign-up/rrhh`
  /// and then establishes a session by signing in with [email]/[password].
  ///
  /// The classic sign-up endpoint returns the created profile (not a token), so
  /// the JWT session is obtained through the follow-up sign-in. Throws on
  /// failure (e.g. the email is already in use).
  Future<AuthSession> signUpRrhh({
    required RrhhProfileDraft draft,
    required String email,
    required String password,
  });

  /// Completes the second phase of Google sign-up for a new RRHH user via
  /// `POST /authentication/sign-up/rrhh/google`, replaying the verified
  /// [idToken] with the profile [draft], and establishes the returned session.
  Future<AuthSession> completeGoogleRrhhSignUp({
    required String idToken,
    required RrhhProfileDraft draft,
  });

  /// Terminates the active session (clearing the Google session and the local
  /// cache) and emits `null` on [sessionChanges].
  Future<void> signOut();

  /// Releases any resources held by the implementation.
  Future<void> dispose();
}
