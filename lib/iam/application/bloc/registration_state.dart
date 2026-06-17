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

/// Immutable state of the registration form managed by [RegistrationBloc].
final class RegistrationState extends Equatable {
  /// Creates a [RegistrationState].
  const RegistrationState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.status = RegistrationStatus.idle,
    this.errorMessage,
    this.session,
  });

  /// Current username value.
  final String username;

  /// Current corporate email value.
  final String email;

  /// Current password value.
  final String password;

  /// Current confirm-password value.
  final String confirmPassword;

  /// Current lifecycle status.
  final RegistrationStatus status;

  /// Raw diagnostic error message when [status] is [RegistrationStatus.failure].
  final String? errorMessage;

  /// Established session when [status] is [RegistrationStatus.success].
  final AuthSession? session;

  /// Whether the password and its non-empty confirmation match.
  bool get passwordsMatch =>
      password.isNotEmpty && password == confirmPassword;

  /// Whether the form's required fields are filled and the passwords match.
  ///
  /// Corporate-domain verification is enforced by the view (which drives the
  /// "✓ Verified domain" badge), keeping this layer free of presentation utils.
  bool get hasRequiredFields =>
      username.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      passwordsMatch &&
      status != RegistrationStatus.submitting;

  /// Returns a copy overriding the provided fields. [errorMessage]/[session]
  /// use a sentinel so they can be explicitly cleared to `null`.
  RegistrationState copyWith({
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    RegistrationStatus? status,
    Object? errorMessage = _sentinel,
    Object? session = _sentinel,
  }) {
    return RegistrationState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
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
        username,
        email,
        password,
        confirmPassword,
        status,
        errorMessage,
        session,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
