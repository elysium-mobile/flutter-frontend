import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart';

/// Outbound request payload provisioning a new employee account.
///
/// A serialization-only boundary carrying the verified Firebase [idToken] (so
/// the backend can trust email ownership) together with the employee-supplied
/// profile fields. Marked outbound-only via `createFactory: false`, so only the
/// generated `toJson` schema is emitted.
@JsonSerializable(createFactory: false)
class RegisterRequest {
  /// Creates an immutable [RegisterRequest] from its explicit fields.
  const RegisterRequest({
    required this.idToken,
    required this.username,
    required this.email,
  });

  /// Short-lived Firebase ID token proving the caller's verified identity.
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Chosen public display name for the new account.
  @JsonKey(name: 'username')
  final String username;

  /// Corporate email address to bind to the new account.
  @JsonKey(name: 'email')
  final String email;

  /// Serializes this request into a JSON-compatible map via the generated
  /// schema.
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
