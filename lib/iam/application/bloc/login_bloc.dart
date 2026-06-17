import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/auth_session.dart';
import '../../domain/stores/authentication_store.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Business Logic Component orchestrating the email and Google login flows.
///
/// The only place where UI intents are translated into [AuthenticationStore]
/// calls and reduced into a renderable [LoginState]. No navigation or widget
/// concern leaks in here; the presentation layer reacts to [LoginStatus].
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Creates a [LoginBloc] bound to the [AuthenticationStore] port.
  LoginBloc({required AuthenticationStore authenticationStore})
      : _authenticationStore = authenticationStore, // ignore: prefer_initializing_formals
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginGoogleSubmitted>(_onGoogleSubmitted);
  }

  final AuthenticationStore _authenticationStore;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
      status: LoginStatus.idle,
      errorMessage: null,
    ));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      status: LoginStatus.idle,
      errorMessage: null,
    ));
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) {
    return _runAuthentication(
      emit,
      () => _authenticationStore.signInWithEmail(
        email: state.email.trim(),
        password: state.password,
      ),
    );
  }

  Future<void> _onGoogleSubmitted(
    LoginGoogleSubmitted event,
    Emitter<LoginState> emit,
  ) {
    return _runAuthentication(emit, _authenticationStore.signInWithGoogle);
  }

  /// Shared executor emitting the submitting → success/failure lifecycle and
  /// performing the single error-translation point of the login flow.
  Future<void> _runAuthentication(
    Emitter<LoginState> emit,
    Future<AuthSession> Function() operation,
  ) async {
    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: null));
    try {
      final session = await operation();
      emit(state.copyWith(status: LoginStatus.success, session: session));
    } catch (error) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
