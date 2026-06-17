part of 'session_bloc.dart';

/// Base type for every intent processed by [SessionBloc].
sealed class SessionEvent extends Equatable {
  /// Const constructor for subclasses.
  const SessionEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Internal event raised whenever the underlying [AuthenticationStore] publishes
/// a new session value (including `null` on sign-out).
final class SessionStoreUpdated extends SessionEvent {
  /// Creates a [SessionStoreUpdated] carrying the latest [session].
  const SessionStoreUpdated(this.session);

  /// The latest session, or `null` when unauthenticated.
  final AuthSession? session;

  @override
  List<Object?> get props => <Object?>[session];
}

/// Public intent requesting global termination of the active session.
final class SessionSignOutRequested extends SessionEvent {
  /// Creates a [SessionSignOutRequested].
  const SessionSignOutRequested();
}
