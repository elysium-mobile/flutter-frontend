/// Immutable set of RRHH profile fields collected during sign-up.
///
/// Shared by both sign-up paths against the ELYSIUM API: the classic
/// email/password `POST /authentication/sign-up/rrhh` and the Google-backed
/// `POST /authentication/sign-up/rrhh/google`. Pure by construction (no
/// serialization or infrastructure imports), with hand-written value equality.
///
/// The Google path does not carry [anonymousName] (the backend auto-generates it
/// and derives the email from the verified token), so that field is optional and
/// simply ignored when completing a Google registration.
class RrhhProfileDraft {
  /// Creates an immutable [RrhhProfileDraft].
  const RrhhProfileDraft({
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.dni,
    required this.rrhhDepartment,
    required this.statusHierarchy,
    this.anonymousName = '',
  });

  /// Employee legal first name (`name`).
  final String name;

  /// Employee legal last name (`last_name`).
  final String lastName;

  /// Contact phone number (`phone_number`).
  final String phoneNumber;

  /// National identity document (`dni`), 8 characters.
  final String dni;

  /// RRHH department (`rrhhdepartment` — note the collapsed lowercase key).
  final String rrhhDepartment;

  /// Position within the RRHH hierarchy (`status_hierarchy`).
  final String statusHierarchy;

  /// Public/anonymous display name (`anonymous_name`); classic sign-up only.
  final String anonymousName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RrhhProfileDraft &&
        other.name == name &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.dni == dni &&
        other.rrhhDepartment == rrhhDepartment &&
        other.statusHierarchy == statusHierarchy &&
        other.anonymousName == anonymousName;
  }

  @override
  int get hashCode => Object.hash(
        name,
        lastName,
        phoneNumber,
        dni,
        rrhhDepartment,
        statusHierarchy,
        anonymousName,
      );
}
