part of 'login_bloc.dart';

/// Lifecycle status of the login flow, decoupled from any UI representation.
enum LoginStatus {
  /// The form is idle and editable.
  idle,

  /// An authentication request is in flight.
  submitting,

  /// Authentication succeeded; a session is available.
  success,

  /// Google identity verified but no ELYSIUM account exists yet; the RRHH
  /// sign-up form must be completed. Inspect [LoginState.googleIdToken].
  registrationRequired,

  /// Authentication failed; inspect [LoginState.errorMessage].
  failure,
}

/// Immutable state of the login screen managed by [LoginBloc].
final class LoginState extends Equatable {
  /// Creates a [LoginState].
  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordObscured = true,
    this.status = LoginStatus.idle,
    this.errorMessage,
    this.session,
    this.googleIdToken,
    this.googleEmail,
  });

  /// Current email field value.
  final String email;

  /// Current password field value.
  final String password;

  /// Whether the password field hides its characters.
  final bool isPasswordObscured;

  /// Current lifecycle status of the flow.
  final LoginStatus status;

  /// Raw diagnostic error message when [status] is [LoginStatus.failure].
  final String? errorMessage;

  /// Established session when [status] is [LoginStatus.success].
  final AuthSession? session;

  /// Verified Google ID token to replay on the RRHH sign-up form, present when
  /// [status] is [LoginStatus.registrationRequired].
  final String? googleIdToken;

  /// Google account email accompanying [googleIdToken] (display/lock only).
  final String? googleEmail;

  /// Whether the form holds non-empty credentials and is not mid-submission.
  bool get canSubmit =>
      email.trim().isNotEmpty &&
      password.isNotEmpty &&
      status != LoginStatus.submitting;

  /// Returns a copy overriding the provided fields. [errorMessage], [session],
  /// [googleIdToken] and [googleEmail] use a sentinel so they can be explicitly
  /// cleared to `null`.
  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordObscured,
    LoginStatus? status,
    Object? errorMessage = _sentinel,
    Object? session = _sentinel,
    Object? googleIdToken = _sentinel,
    Object? googleEmail = _sentinel,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      session: identical(session, _sentinel)
          ? this.session
          : session as AuthSession?,
      googleIdToken: identical(googleIdToken, _sentinel)
          ? this.googleIdToken
          : googleIdToken as String?,
      googleEmail: identical(googleEmail, _sentinel)
          ? this.googleEmail
          : googleEmail as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        email,
        password,
        isPasswordObscured,
        status,
        errorMessage,
        session,
        googleIdToken,
        googleEmail,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
