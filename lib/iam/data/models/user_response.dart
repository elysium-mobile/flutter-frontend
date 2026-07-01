import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/user.dart';

part 'user_response.g.dart';

/// Inbound network contract describing the user profile payload returned by the
/// backend.
///
/// A raw serialization boundary aligned with [AuthSessionResponse]: it mirrors
/// the wire schema exactly and carries no business behavior. Deserialization is
/// delegated to the generated `@JsonSerializable` schema; projection into the
/// pure domain layer is exposed through [toDomain]. Marked inbound-only
/// (`createToJson: false`) since the client never serializes this type outward.
@JsonSerializable(createToJson: false)
class UserResponse {
  /// Creates a [UserResponse] from its explicit wire fields.
  const UserResponse({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Server-driven unique identifier of the user.
  @JsonKey(name: 'id')
  final String id;

  /// Public display name of the user.
  @JsonKey(name: 'name')
  final String name;

  /// Institutional email address bound to the user account.
  @JsonKey(name: 'email')
  final String email;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [User] entity.
  ///
  /// Signature only: the mapping body is intentionally left for the automation
  /// agent to generate.
  User toDomain() => throw UnimplementedError();
}
