import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/rrhh_profile_draft.dart';

part 'rrhh_profile_sign_up_request.g.dart';

/// Outbound request payload for `POST /api/v1/authentication/sign-up/rrhh`
/// (`RRHHProfileSignUpRequest`).
///
/// Carries the full RRHH profile plus credentials. A serialization-only boundary
/// marked outbound-only via `createFactory: false`.
///
/// Note the collapsed key [rrhhDepartment] → `rrhhdepartment` (no underscore):
/// the Java field is `RRHHDepartment` and Jackson's `SnakeCaseStrategy` does not
/// split leading consecutive capitals.
@JsonSerializable(createFactory: false)
class RrhhProfileSignUpRequest {
  /// Creates an immutable [RrhhProfileSignUpRequest].
  const RrhhProfileSignUpRequest({
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.dni,
    required this.email,
    required this.password,
    required this.anonymousName,
    required this.rrhhDepartment,
    required this.statusHierarchy,
  });

  /// Builds a request from a domain [draft] and the account credentials.
  factory RrhhProfileSignUpRequest.fromDraft({
    required RrhhProfileDraft draft,
    required String email,
    required String password,
  }) {
    return RrhhProfileSignUpRequest(
      name: draft.name,
      lastName: draft.lastName,
      phoneNumber: draft.phoneNumber,
      dni: draft.dni,
      email: email,
      password: password,
      anonymousName: draft.anonymousName,
      rrhhDepartment: draft.rrhhDepartment,
      statusHierarchy: draft.statusHierarchy,
    );
  }

  /// Legal first name.
  @JsonKey(name: 'name')
  final String name;

  /// Legal last name.
  @JsonKey(name: 'last_name')
  final String lastName;

  /// Contact phone number.
  @JsonKey(name: 'phone_number')
  final String phoneNumber;

  /// National identity document (8 chars).
  @JsonKey(name: 'dni')
  final String dni;

  /// Institutional email address to bind to the account.
  @JsonKey(name: 'email')
  final String email;

  /// Account password.
  @JsonKey(name: 'password')
  final String password;

  /// Public/anonymous display name.
  @JsonKey(name: 'anonymous_name')
  final String anonymousName;

  /// RRHH department (collapsed lowercase key `rrhhdepartment`).
  @JsonKey(name: 'rrhhdepartment')
  final String rrhhDepartment;

  /// Position within the RRHH hierarchy.
  @JsonKey(name: 'status_hierarchy')
  final String statusHierarchy;

  /// Serializes this request via the generated schema.
  Map<String, dynamic> toJson() => _$RrhhProfileSignUpRequestToJson(this);
}
