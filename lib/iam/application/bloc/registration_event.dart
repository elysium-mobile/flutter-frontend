part of 'registration_bloc.dart';

/// Base type for every intent the registration form dispatches to
/// [RegistrationBloc].
sealed class RegistrationEvent extends Equatable {
  /// Const constructor for subclasses.
  const RegistrationEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The username field changed.
final class RegistrationUsernameChanged extends RegistrationEvent {
  /// Creates a [RegistrationUsernameChanged].
  const RegistrationUsernameChanged(this.username);

  /// Latest username value.
  final String username;

  @override
  List<Object?> get props => <Object?>[username];
}

/// The corporate email field changed.
final class RegistrationEmailChanged extends RegistrationEvent {
  /// Creates a [RegistrationEmailChanged].
  const RegistrationEmailChanged(this.email);

  /// Latest email value.
  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}

/// The password field changed.
final class RegistrationPasswordChanged extends RegistrationEvent {
  /// Creates a [RegistrationPasswordChanged].
  const RegistrationPasswordChanged(this.password);

  /// Latest password value.
  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

/// The confirm-password field changed.
final class RegistrationConfirmPasswordChanged extends RegistrationEvent {
  /// Creates a [RegistrationConfirmPasswordChanged].
  const RegistrationConfirmPasswordChanged(this.confirmPassword);

  /// Latest confirm-password value.
  final String confirmPassword;

  @override
  List<Object?> get props => <Object?>[confirmPassword];
}

/// The primary "Create account" button was pressed.
final class RegistrationSubmitted extends RegistrationEvent {
  /// Creates a [RegistrationSubmitted].
  const RegistrationSubmitted();
}
