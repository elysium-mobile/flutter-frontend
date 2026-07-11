import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/user.dart';

part 'authenticated_user_account_response.g.dart';

/// Inbound network contract for `AuthenticatedUserAccountResponse`, the payload
/// returned by the ELYSIUM sign-in and Google sign-up endpoints.
///
/// Shape: `{ "id", "email", "token" }`. A raw serialization boundary, inbound
/// only (`createToJson: false`); the projection into the pure domain layer is
/// exposed through [toDomain].
@JsonSerializable(createToJson: false)
class AuthenticatedUserAccountResponse {
  /// Creates an [AuthenticatedUserAccountResponse] from its wire fields.
  const AuthenticatedUserAccountResponse({
    required this.id,
    required this.email,
    required this.token,
  });

  /// Server-driven user-account identifier.
  @JsonKey(name: 'id')
  final int id;

  /// Institutional email address bound to the account.
  @JsonKey(name: 'email')
  final String email;

  /// Application JWT authorizing subsequent requests.
  @JsonKey(name: 'token')
  final String token;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory AuthenticatedUserAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserAccountResponseFromJson(json);

  /// Projects this response onto a pure-domain [AuthSession].
  ///
  /// The contract carries no display name, so the username is derived from the
  /// email local-part (the segment before `@`) as a stable, truthful fallback.
  AuthSession toDomain() {
    return AuthSession(
      user: User(
        id: Id(id.toString()),
        username: email.contains('@') ? email.split('@').first : email,
        email: email,
      ),
      accessToken: token,
    );
  }
}
