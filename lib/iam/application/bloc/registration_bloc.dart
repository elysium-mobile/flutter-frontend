import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/auth_session.dart';
import '../../domain/models/rrhh_profile_draft.dart';
import '../../domain/stores/authentication_store.dart';

part 'registration_event.dart';
part 'registration_state.dart';

/// Business Logic Component orchestrating the RRHH registration flow.
///
/// Owns form-field reduction and the single error-translation point, exposing a
/// renderable [RegistrationState]. It drives both sign-up paths against the
/// ELYSIUM API: the classic email/password sign-up, and the phase-2 Google
/// sign-up (when a [RegistrationGoogleContextProvided] has seeded a verified
/// id token). It never performs navigation; views react to
/// [RegistrationStatus] transitions.
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  /// Creates a [RegistrationBloc] bound to the [AuthenticationStore] port.
  RegistrationBloc({required AuthenticationStore authenticationStore})
      : _authenticationStore = authenticationStore, // ignore: prefer_initializing_formals
        super(const RegistrationState()) {
    on<RegistrationGoogleContextProvided>(_onGoogleContextProvided);
    on<RegistrationNameChanged>(_onNameChanged);
    on<RegistrationLastNameChanged>(_onLastNameChanged);
    on<RegistrationPhoneChanged>(_onPhoneChanged);
    on<RegistrationDniChanged>(_onDniChanged);
    on<RegistrationAnonymousNameChanged>(_onAnonymousNameChanged);
    on<RegistrationDepartmentChanged>(_onDepartmentChanged);
    on<RegistrationHierarchyChanged>(_onHierarchyChanged);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegistrationSubmitted>(_onSubmitted);
  }

  final AuthenticationStore _authenticationStore;

  void _onGoogleContextProvided(
    RegistrationGoogleContextProvided event,
    Emitter<RegistrationState> emit,
  ) {
    emit(state.copyWith(
      googleIdToken: event.idToken,
      email: event.email,
      status: RegistrationStatus.idle,
      errorMessage: null,
    ));
  }

  void _onNameChanged(
    RegistrationNameChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(name: event.name, status: RegistrationStatus.idle));

  void _onLastNameChanged(
    RegistrationLastNameChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        lastName: event.lastName,
        status: RegistrationStatus.idle,
      ));

  void _onPhoneChanged(
    RegistrationPhoneChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        status: RegistrationStatus.idle,
      ));

  void _onDniChanged(
    RegistrationDniChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(dni: event.dni, status: RegistrationStatus.idle));

  void _onAnonymousNameChanged(
    RegistrationAnonymousNameChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        anonymousName: event.anonymousName,
        status: RegistrationStatus.idle,
      ));

  void _onDepartmentChanged(
    RegistrationDepartmentChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        rrhhDepartment: event.rrhhDepartment,
        status: RegistrationStatus.idle,
      ));

  void _onHierarchyChanged(
    RegistrationHierarchyChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        statusHierarchy: event.statusHierarchy,
        status: RegistrationStatus.idle,
      ));

  void _onEmailChanged(
    RegistrationEmailChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(email: event.email, status: RegistrationStatus.idle));

  void _onPasswordChanged(
    RegistrationPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        password: event.password,
        status: RegistrationStatus.idle,
      ));

  void _onConfirmPasswordChanged(
    RegistrationConfirmPasswordChanged event,
    Emitter<RegistrationState> emit,
  ) =>
      emit(state.copyWith(
        confirmPassword: event.confirmPassword,
        status: RegistrationStatus.idle,
      ));

  Future<void> _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(
      status: RegistrationStatus.submitting,
      errorMessage: null,
    ));
    try {
      final RrhhProfileDraft draft = RrhhProfileDraft(
        name: state.name.trim(),
        lastName: state.lastName.trim(),
        phoneNumber: state.phoneNumber.trim(),
        dni: state.dni.trim(),
        rrhhDepartment: state.rrhhDepartment.trim(),
        statusHierarchy: state.statusHierarchy.trim(),
        anonymousName: state.anonymousName.trim(),
      );

      final String? googleIdToken = state.googleIdToken;
      final AuthSession session = googleIdToken != null
          ? await _authenticationStore.completeGoogleRrhhSignUp(
              idToken: googleIdToken,
              draft: draft,
            )
          : await _authenticationStore.signUpRrhh(
              draft: draft,
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
