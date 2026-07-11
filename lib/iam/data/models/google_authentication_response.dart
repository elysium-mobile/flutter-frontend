import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/user.dart';

part 'google_authentication_response.g.dart';

/// Inbound network contract for `GoogleAuthenticationResponse`, returned by
/// `POST /api/v1/authentication/google` (the phase-1 identity check).
///
/// Shape: `{ "registered", "id", "email", "token" }`. When [registered] is
/// `true` the identity maps to an existing account and [token] is present; when
/// `false` the remaining fields are null and the caller must complete phase-2
/// sign-up. A raw serialization boundary, inbound only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class GoogleAuthenticationResponse {
  /// Creates a [GoogleAuthenticationResponse] from its wire fields.
  const GoogleAuthenticationResponse({
    required this.registered,
    this.id,
    this.email,
    this.token,
  });

  /// Whether an ELYSIUM account already exists for the verified identity.
  @JsonKey(name: 'registered')
  final bool registered;

  /// User-account identifier (null when not registered).
  @JsonKey(name: 'id')
  final int? id;

  /// Account email (null when not registered).
  @JsonKey(name: 'email')
  final String? email;

  /// Application JWT (null when not registered).
  @JsonKey(name: 'token')
  final String? token;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory GoogleAuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthenticationResponseFromJson(json);

  /// Projects a **registered** response onto a pure-domain [AuthSession].
  ///
  /// Throws a [StateError] if invoked when [registered] is `false` or the
  /// required fields are missing — callers must branch on [registered] first.
  AuthSession toSession() {
    final int? resolvedId = id;
    final String? resolvedEmail = email;
    final String? resolvedToken = token;
    if (!registered ||
        resolvedId == null ||
        resolvedEmail == null ||
        resolvedToken == null) {
      throw StateError('Google response is not a registered session.');
    }
    return AuthSession(
      user: User(
        id: Id(resolvedId.toString()),
        username: resolvedEmail.contains('@')
            ? resolvedEmail.split('@').first
            : resolvedEmail,
        email: resolvedEmail,
      ),
      accessToken: resolvedToken,
    );
  }
}
