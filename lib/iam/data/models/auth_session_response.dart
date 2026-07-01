import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/auth_session.dart';

part 'auth_session_response.g.dart';

/// Inbound network contract describing the authentication session payload
/// returned by the backend.
///
/// This is a raw serialization boundary: it mirrors the wire schema exactly and
/// carries no business behavior. Deserialization is delegated to the generated
/// `@JsonSerializable` schema; the projection into the pure domain layer is
/// exposed through [toDomain]. Marked inbound-only ([JsonSerializable] with
/// `createToJson: false`) since the client never serializes this type outward.
@JsonSerializable(createToJson: false)
class AuthSessionResponse {
  /// Creates an [AuthSessionResponse] from its explicit wire fields.
  const AuthSessionResponse({
    required this.accessToken,
    required this.userId,
    required this.email,
    required this.username,
  });

  /// Backend-issued bearer access token for the established session.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Server-driven unique identifier of the authenticated user.
  @JsonKey(name: 'user_id')
  final String userId;

  /// Institutional email address bound to the authenticated account.
  @JsonKey(name: 'email')
  final String email;

  /// Public display name of the authenticated user.
  @JsonKey(name: 'username')
  final String username;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory AuthSessionResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [AuthSession] entity.
  ///
  /// Signature only: the mapping body is intentionally left for the automation
  /// agent to generate.
  AuthSession toDomain() => throw UnimplementedError();
}
