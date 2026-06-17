import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/auth_session.dart';
import '../../domain/models/user.dart';
import '../../domain/stores/authentication_store.dart';

part 'session_event.dart';
part 'session_state.dart';

/// Application-wide session state machine and the single reactive source of
/// truth for the dual-router redirection guards.
///
/// On creation it subscribes to [AuthenticationStore.sessionChanges] and mirrors
/// every emission into a [SessionState]. The router listens to this bloc's
/// stream to switch between the unauthenticated and authenticated shells, while
/// authenticated views read [SessionState.user] for personalization.
///
/// This bloc is a long-lived singleton (unlike the volatile login/registration
/// blocs); it must be provided above the router via `BlocProvider.value`.
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  /// Creates a [SessionBloc] bound to the [AuthenticationStore] port.
  SessionBloc({required AuthenticationStore authenticationStore})
      : _authenticationStore = authenticationStore, // ignore: prefer_initializing_formals
        super(const SessionState.unknown()) {
    on<SessionStoreUpdated>(_onStoreUpdated);
    on<SessionSignOutRequested>(_onSignOutRequested);

    _subscription = _authenticationStore
        .sessionChanges()
        .listen((session) => add(SessionStoreUpdated(session)));
  }

  final AuthenticationStore _authenticationStore;
  late final StreamSubscription<AuthSession?> _subscription;

  void _onStoreUpdated(
    SessionStoreUpdated event,
    Emitter<SessionState> emit,
  ) {
    emit(
      SessionState(
        status: event.session == null
            ? SessionStatus.unauthenticated
            : SessionStatus.authenticated,
        session: event.session,
      ),
    );
  }

  Future<void> _onSignOutRequested(
    SessionSignOutRequested event,
    Emitter<SessionState> emit,
  ) async {
    // The resulting `null` emission flows back through [sessionChanges] and is
    // reduced by [_onStoreUpdated]; no optimistic state is emitted here.
    await _authenticationStore.signOut();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
