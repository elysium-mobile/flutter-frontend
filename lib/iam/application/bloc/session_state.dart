part of 'session_bloc.dart';

/// Global authentication status driving the dual-router redirection strategy.
enum SessionStatus {
  /// The session has not been resolved yet (initial, pre-bootstrap value).
  unknown,

  /// An authenticated session is active.
  authenticated,

  /// No session is active.
  unauthenticated,
}

/// Immutable global session state exposed to the router and authenticated UI.
final class SessionState extends Equatable {
  /// Creates a [SessionState].
  const SessionState({required this.status, this.session});

  /// Creates the initial, unresolved state.
  const SessionState.unknown()
      : status = SessionStatus.unknown,
        session = null;

  /// Current global authentication status.
  final SessionStatus status;

  /// The active session, or `null` when not authenticated.
  final AuthSession? session;

  /// Whether an authenticated session is currently active.
  bool get isAuthenticated => status == SessionStatus.authenticated;

  /// The authenticated user, or `null` when not authenticated.
  User? get user => session?.user;

  @override
  List<Object?> get props => <Object?>[status, session];
}
