import 'auth_session.dart';

/// Outcome of the first phase of Google authentication against the ELYSIUM API
/// (`POST /api/v1/authentication/google`).
///
/// The backend validates the Google `id_token` and reports whether an account
/// already exists. This sealed hierarchy models the two mutually exclusive
/// results so the application layer can branch exhaustively without inspecting
/// nullable fields.
sealed class GoogleAuthResult {
  /// Const base constructor for subclasses.
  const GoogleAuthResult();
}

/// The Google identity already maps to an ELYSIUM account: a session is issued.
final class GoogleAuthenticated extends GoogleAuthResult {
  /// Creates a [GoogleAuthenticated] carrying the established [session].
  const GoogleAuthenticated(this.session);

  /// The established, ready-to-use authentication session.
  final AuthSession session;
}

/// The Google identity is valid but has no ELYSIUM account yet.
///
/// The verified [idToken] must be forwarded to the phase-2 RRHH sign-up endpoint
/// together with the profile fields; [email] is the Google account email,
/// carried purely to pre-fill and lock the sign-up form.
final class GoogleRegistrationRequired extends GoogleAuthResult {
  /// Creates a [GoogleRegistrationRequired].
  const GoogleRegistrationRequired({
    required this.idToken,
    required this.email,
  });

  /// The verified Google ID token to replay on the phase-2 sign-up call.
  final String idToken;

  /// The Google account email (display/lock only; the backend re-derives it
  /// from the token).
  final String email;
}
