import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../iam/domain/models/auth_session.dart';
import '../../../iam/domain/stores/authentication_store.dart';
import '../../domain/models/membership.dart';
import '../../domain/repositories/payment_repository.dart';

part 'membership_gate_event.dart';
part 'membership_gate_state.dart';

/// Long-lived state machine tracking the authenticated user's membership status
/// for the router's redirection automation.
///
/// It subscribes to [AuthenticationStore.sessionChanges] and, whenever a session
/// becomes active, resolves the locally-synchronized membership into a
/// [MembershipGateStatus]. The router consults [state] to intercept the
/// profile-configuration route into the renewal flow when the membership is
/// [MembershipGateStatus.expired].
///
/// The gate never blocks on [MembershipGateStatus.absent] or
/// [MembershipGateStatus.unknown], so users are never trapped when a membership
/// simply cannot be determined.
class MembershipGateBloc
    extends Bloc<MembershipGateEvent, MembershipGateState> {
  /// Creates a [MembershipGateBloc] bound to its collaborators.
  MembershipGateBloc({
    required PaymentRepository repository,
    required AuthenticationStore authenticationStore,
  })  : _repository = repository, // ignore: prefer_initializing_formals
        // ignore: prefer_initializing_formals
        _authenticationStore = authenticationStore,
        super(const MembershipGateState.unknown()) {
    on<MembershipGateRefreshed>(_onRefreshed);
    on<MembershipGateActivated>(_onActivated);
    on<MembershipGateCleared>(_onCleared);

    _subscription = _authenticationStore.sessionChanges().listen((session) {
      add(session == null
          ? const MembershipGateCleared()
          : const MembershipGateRefreshed());
    });
  }

  final PaymentRepository _repository;
  final AuthenticationStore _authenticationStore;
  late final StreamSubscription<AuthSession?> _subscription;

  /// Resolves the synchronized membership into a gate status.
  Future<void> _onRefreshed(
    MembershipGateRefreshed event,
    Emitter<MembershipGateState> emit,
  ) async {
    emit(state.copyWith(status: MembershipGateStatus.resolving));
    try {
      final Membership? membership = await _repository.loadCurrentMembership();
      emit(_resolve(membership));
    } catch (_) {
      // Never block on an indeterminate result.
      emit(const MembershipGateState(status: MembershipGateStatus.unknown));
    }
  }

  /// Optimistically marks the gate active after a successful purchase.
  void _onActivated(
    MembershipGateActivated event,
    Emitter<MembershipGateState> emit,
  ) {
    emit(MembershipGateState(
      status: MembershipGateStatus.active,
      membership: event.membership,
    ));
  }

  /// Resets the gate when the session ends.
  void _onCleared(
    MembershipGateCleared event,
    Emitter<MembershipGateState> emit,
  ) {
    emit(const MembershipGateState.unknown());
  }

  /// Maps a resolved [membership] onto the gate state.
  MembershipGateState _resolve(Membership? membership) {
    if (membership == null) {
      return const MembershipGateState(status: MembershipGateStatus.absent);
    }
    return MembershipGateState(
      status: membership.isCurrentlyActive
          ? MembershipGateStatus.active
          : MembershipGateStatus.expired,
      membership: membership,
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
