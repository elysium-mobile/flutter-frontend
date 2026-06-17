import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/auth_session.dart';
import '../../domain/stores/authentication_store.dart';

part 'registration_event.dart';
part 'registration_state.dart';

/// Business Logic Component orchestrating the employee registration flow.
///
/// Owns form-field reduction and the single error-translation point, exposing a
/// renderable [RegistrationState]. It never performs navigation; views react to
/// [RegistrationStatus] transitions.
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  /// Creates a [RegistrationBloc] bound to the [AuthenticationStore] port.
  RegistrationBloc({required AuthenticationStore authenticationStore})
      : _authenticationStore = authenticationStore, // ignore: prefer_initializing_formals
        super(const RegistrationState()) {
    on<RegistrationUsernameChanged>(_onUsernameChanged);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  final AuthenticationStore _authenticationStore;

  void _onUsernameChanged(
    RegistrationUsernameChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      username: event.username,
      status: RegistrationStatus.idle,
      errorMessage: null,
    ));
  }

  void _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      status: RegistrationStatus.idle,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: RegistrationStatus.idle,
      errorMessage: null,
    ));
  }

  void _onConfirmPasswordChanged(
    RegistrationConfirmPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      status: RegistrationStatus.idle,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(
      status: RegistrationStatus.submitting,
      errorMessage: null,
    ));
    try {
      final AuthSession session = await _authenticationStore.registerWithEmail(
        username: state.username.trim(),
        email: state.email.trim(),
        password: state.password,
      );
      emit(state.copyWith(
        status: RegistrationStatus.success,
        session: session,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: RegistrationStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
