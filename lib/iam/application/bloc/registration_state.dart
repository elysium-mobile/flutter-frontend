part of 'registration_bloc.dart';

/// Lifecycle status of the registration flow.
enum RegistrationStatus {
  /// The form is idle and editable.
  idle,

  /// A registration request is in flight.
  submitting,

  /// Registration succeeded; a session is available.
  success,

  /// Registration failed; inspect [RegistrationState.errorMessage].
  failure,
}

/// Immutable state of the RRHH registration form managed by [RegistrationBloc].
///
/// Supports two modes behind one state object: the classic email/password
/// sign-up, and the phase-2 Google sign-up (when [googleIdToken] is non-null),
/// where the email is prefilled/locked and the password fields are omitted.
final class RegistrationState extends Equatable {
  /// Creates a [RegistrationState].
  const RegistrationState({
    this.name = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.dni = '',
    this.anonymousName = '',
    this.rrhhDepartment = '',
    this.statusHierarchy = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.googleIdToken,
    this.status = RegistrationStatus.idle,
    this.errorMessage,
    this.session,
  });

  /// Legal first name.
  final String name;

  /// Legal last name.
  final String lastName;

  /// Contact phone number.
  final String phoneNumber;

  /// National identity document.
  final String dni;

  /// Public/anonymous display name (classic mode only).
  final String anonymousName;

  /// RRHH department.
  final String rrhhDepartment;

  /// Position within the RRHH hierarchy.
  final String statusHierarchy;

  /// Corporate email value.
  final String email;

  /// Password value (classic mode only).
  final String password;

  /// Confirm-password value (classic mode only).
  final String confirmPassword;

  /// Verified Google ID token; non-null switches the form to Google mode.
  final String? googleIdToken;

  /// Current lifecycle status.
  final RegistrationStatus status;

  /// Raw diagnostic error message when [status] is [RegistrationStatus.failure].
  final String? errorMessage;

  /// Established session when [status] is [RegistrationStatus.success].
  final AuthSession? session;

  /// Whether the form is completing a Google (phase-2) sign-up.
  bool get isGoogleMode => googleIdToken != null;

  /// Whether the password and its non-empty confirmation match.
  bool get passwordsMatch =>
      password.isNotEmpty && password == confirmPassword;

  /// Whether the RRHH profile fields common to both modes are filled.
  bool get _hasCommonFields =>
      name.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      phoneNumber.trim().isNotEmpty &&
      dni.trim().isNotEmpty &&
      rrhhDepartment.trim().isNotEmpty &&
      statusHierarchy.trim().isNotEmpty;

  /// Whether the form can be submitted.
  ///
  /// Google mode requires only the common profile fields (email is locked, no
  /// password); classic mode additionally requires the email, a matching
  /// password pair and the anonymous name. Corporate-domain verification is
  /// enforced by the view, keeping this layer free of presentation utils.
  bool get canSubmit {
    if (status == RegistrationStatus.submitting || !_hasCommonFields) {
      return false;
    }
    if (isGoogleMode) return true;
    return email.trim().isNotEmpty &&
        anonymousName.trim().isNotEmpty &&
        passwordsMatch;
  }

  /// Returns a copy overriding the provided fields. [errorMessage], [session]
  /// and [googleIdToken] use a sentinel so they can be explicitly cleared.
  RegistrationState copyWith({
    String? name,
    String? lastName,
    String? phoneNumber,
    String? dni,
    String? anonymousName,
    String? rrhhDepartment,
    String? statusHierarchy,
    String? email,
    String? password,
    String? confirmPassword,
    Object? googleIdToken = _sentinel,
    RegistrationStatus? status,
    Object? errorMessage = _sentinel,
    Object? session = _sentinel,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dni: dni ?? this.dni,
      anonymousName: anonymousName ?? this.anonymousName,
      rrhhDepartment: rrhhDepartment ?? this.rrhhDepartment,
      statusHierarchy: statusHierarchy ?? this.statusHierarchy,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      googleIdToken: identical(googleIdToken, _sentinel)
          ? this.googleIdToken
          : googleIdToken as String?,
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      session: identical(session, _sentinel)
          ? this.session
          : session as AuthSession?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        name,
        lastName,
        phoneNumber,
        dni,
        anonymousName,
        rrhhDepartment,
        statusHierarchy,
        email,
        password,
        confirmPassword,
        googleIdToken,
        status,
        errorMessage,
        session,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
