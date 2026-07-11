import 'package:json_annotation/json_annotation.dart';

import '../../../domain/models/rrhh_profile_draft.dart';

part 'google_rrhh_sign_up_request.g.dart';

/// Outbound request payload for `POST /api/v1/authentication/sign-up/rrhh/google`
/// (`GoogleRRHHSignUpRequest`).
///
/// Replays the verified Google [idToken] together with the RRHH profile fields.
/// No `email`, `password` or `anonymous_name` is sent: the backend derives the
/// email from the token, sets a random password (password login is disabled for
/// Google accounts) and auto-generates the anonymous name. A serialization-only
/// boundary marked outbound-only via `createFactory: false`.
@JsonSerializable(createFactory: false)
class GoogleRrhhSignUpRequest {
  /// Creates an immutable [GoogleRrhhSignUpRequest].
  const GoogleRrhhSignUpRequest({
    required this.idToken,
    required this.name,
    required this.lastName,
    required this.phoneNumber,
    required this.dni,
    required this.rrhhDepartment,
    required this.statusHierarchy,
  });

  /// Builds a request from a verified [idToken] and a domain [draft].
  factory GoogleRrhhSignUpRequest.fromDraft({
    required String idToken,
    required RrhhProfileDraft draft,
  }) {
    return GoogleRrhhSignUpRequest(
      idToken: idToken,
      name: draft.name,
      lastName: draft.lastName,
      phoneNumber: draft.phoneNumber,
      dni: draft.dni,
      rrhhDepartment: draft.rrhhDepartment,
      statusHierarchy: draft.statusHierarchy,
    );
  }

  /// The verified Google ID token; the backend re-validates it.
  @JsonKey(name: 'id_token')
  final String idToken;

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

  /// RRHH department (collapsed lowercase key `rrhhdepartment`).
  @JsonKey(name: 'rrhhdepartment')
  final String rrhhDepartment;

  /// Position within the RRHH hierarchy.
  @JsonKey(name: 'status_hierarchy')
  final String statusHierarchy;

  /// Serializes this request via the generated schema.
  Map<String, dynamic> toJson() => _$GoogleRrhhSignUpRequestToJson(this);
}
