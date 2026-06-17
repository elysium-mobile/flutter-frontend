import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/auth_session.dart';
import 'user_dto.dart';

/// Data Transfer Object mirroring the authentication session payload returned by
/// the backend after a successful sign-in or registration exchange.
///
/// Serialization intent is declared via metadata while the conversion bodies are
/// explicit. Domain mapping happens only in [toDomain].
@JsonSerializable()
class AuthSessionDto {
  /// Creates an [AuthSessionDto].
  const AuthSessionDto({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  /// The authenticated user profile.
  @JsonKey(name: 'user')
  final UserDto user;

  /// Backend-issued bearer token.
  @JsonKey(name: 'access_token')
  final String accessToken;

  /// Optional refresh token.
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  /// Optional ISO-8601 expiry timestamp of [accessToken].
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  /// Builds an [AuthSessionDto] from a decoded JSON [json] map.
  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    return AuthSessionDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] as String?,
    );
  }

  /// Serializes this DTO into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt,
    };
  }

  /// Projects this DTO onto the pure-domain [AuthSession], parsing the expiry
  /// defensively (a malformed value degrades to `null`).
  AuthSession toDomain() {
    final rawExpiry = expiresAt;
    return AuthSession(
      user: user.toDomain(),
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: rawExpiry == null ? null : DateTime.tryParse(rawExpiry),
    );
  }
}
