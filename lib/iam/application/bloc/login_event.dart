part of 'login_bloc.dart';

/// Base type for every intent the login screen dispatches to [LoginBloc].
sealed class LoginEvent extends Equatable {
  /// Const constructor for subclasses.
  const LoginEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The institutional email field changed.
final class LoginEmailChanged extends LoginEvent {
  /// Creates a [LoginEmailChanged].
  const LoginEmailChanged(this.email);

  /// Latest email value.
  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}

/// The password field changed.
final class LoginPasswordChanged extends LoginEvent {
  /// Creates a [LoginPasswordChanged].
  const LoginPasswordChanged(this.password);

  /// Latest password value.
  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

/// The password visibility toggle was tapped.
final class LoginPasswordVisibilityToggled extends LoginEvent {
  /// Creates a [LoginPasswordVisibilityToggled].
  const LoginPasswordVisibilityToggled();
}

/// The primary "Sign In" button was pressed.
final class LoginSubmitted extends LoginEvent {
  /// Creates a [LoginSubmitted].
  const LoginSubmitted();
}

/// The "Continue with Google" button was pressed.
final class LoginGoogleSubmitted extends LoginEvent {
  /// Creates a [LoginGoogleSubmitted].
  const LoginGoogleSubmitted();
}
