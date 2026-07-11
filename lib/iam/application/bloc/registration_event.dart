part of 'registration_bloc.dart';

/// Base type for every intent the registration form dispatches to
/// [RegistrationBloc].
sealed class RegistrationEvent extends Equatable {
  /// Const constructor for subclasses.
  const RegistrationEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Seeds the form with a verified Google context, switching it into the
/// phase-2 Google RRHH sign-up mode (email locked, password fields hidden).
final class RegistrationGoogleContextProvided extends RegistrationEvent {
  /// Creates a [RegistrationGoogleContextProvided].
  const RegistrationGoogleContextProvided({
    required this.idToken,
    required this.email,
  });

  /// Verified Google ID token to replay on submit.
  final String idToken;

  /// Google account email (prefilled and locked).
  final String email;

  @override
  List<Object?> get props => <Object?>[idToken, email];
}

/// The first-name field changed.
final class RegistrationNameChanged extends RegistrationEvent {
  /// Creates a [RegistrationNameChanged].
  const RegistrationNameChanged(this.name);

  /// Latest first-name value.
  final String name;

  @override
  List<Object?> get props => <Object?>[name];
}

/// The last-name field changed.
final class RegistrationLastNameChanged extends RegistrationEvent {
  /// Creates a [RegistrationLastNameChanged].
  const RegistrationLastNameChanged(this.lastName);

  /// Latest last-name value.
  final String lastName;

  @override
  List<Object?> get props => <Object?>[lastName];
}

/// The phone-number field changed.
final class RegistrationPhoneChanged extends RegistrationEvent {
  /// Creates a [RegistrationPhoneChanged].
  const RegistrationPhoneChanged(this.phoneNumber);

  /// Latest phone-number value.
  final String phoneNumber;

  @override
  List<Object?> get props => <Object?>[phoneNumber];
}

/// The DNI field changed.
final class RegistrationDniChanged extends RegistrationEvent {
  /// Creates a [RegistrationDniChanged].
  const RegistrationDniChanged(this.dni);

  /// Latest DNI value.
  final String dni;

  @override
  List<Object?> get props => <Object?>[dni];
}

/// The anonymous-name (public display name) field changed.
final class RegistrationAnonymousNameChanged extends RegistrationEvent {
  /// Creates a [RegistrationAnonymousNameChanged].
  const RegistrationAnonymousNameChanged(this.anonymousName);

  /// Latest anonymous-name value.
  final String anonymousName;

  @override
  List<Object?> get props => <Object?>[anonymousName];
}

/// The RRHH-department field changed.
final class RegistrationDepartmentChanged extends RegistrationEvent {
  /// Creates a [RegistrationDepartmentChanged].
  const RegistrationDepartmentChanged(this.rrhhDepartment);

  /// Latest department value.
  final String rrhhDepartment;

  @override
  List<Object?> get props => <Object?>[rrhhDepartment];
}

/// The status-hierarchy field changed.
final class RegistrationHierarchyChanged extends RegistrationEvent {
  /// Creates a [RegistrationHierarchyChanged].
  const RegistrationHierarchyChanged(this.statusHierarchy);

  /// Latest hierarchy value.
  final String statusHierarchy;

  @override
  List<Object?> get props => <Object?>[statusHierarchy];
}

/// The corporate email field changed (classic mode only).
final class RegistrationEmailChanged extends RegistrationEvent {
  /// Creates a [RegistrationEmailChanged].
  const RegistrationEmailChanged(this.email);

  /// Latest email value.
  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}

/// The password field changed (classic mode only).
final class RegistrationPasswordChanged extends RegistrationEvent {
  /// Creates a [RegistrationPasswordChanged].
  const RegistrationPasswordChanged(this.password);

  /// Latest password value.
  final String password;

  @override
  List<Object?> get props => <Object?>[password];
}

/// The confirm-password field changed (classic mode only).
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
