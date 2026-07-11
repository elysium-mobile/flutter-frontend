import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request.g.dart';

/// Outbound request payload for `POST /api/v1/authentication/sign-in`.
///
/// Carries the RRHH user's institutional [email] and [password]. A
/// serialization-only boundary marked outbound-only via `createFactory: false`,
/// so only the generated `toJson` schema is emitted. The backend answers with an
/// `AuthenticatedUserAccountResponse` (`{id, email, token}`).
@JsonSerializable(createFactory: false)
class SignInRequest {
  /// Creates an immutable [SignInRequest] from an [email]/[password] pair.
  const SignInRequest({required this.email, required this.password});

  /// Institutional email address of the account.
  @JsonKey(name: 'email')
  final String email;

  /// Account password.
  @JsonKey(name: 'password')
  final String password;

  /// Serializes this request into a JSON-compatible map via the generated
  /// schema.
  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}
