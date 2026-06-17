import 'package:json_annotation/json_annotation.dart';

/// Request payload provisioning a new employee account.
///
/// Carries the verified Firebase [idToken] (so the backend can trust email
/// ownership) together with the employee-supplied profile fields. Roles have
/// been removed from the registration contract.
@JsonSerializable()
class RegisterRequest {
  /// Creates a [RegisterRequest].
  const RegisterRequest({
    required this.idToken,
    required this.username,
    required this.email,
  });

  /// Short-lived Firebase ID token proving the caller's verified identity.
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Chosen public display name.
  @JsonKey(name: 'username')
  final String username;

  /// Corporate email address to bind to the account.
  @JsonKey(name: 'email')
  final String email;

  /// Serializes this request into a JSON-compatible map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id_token': idToken,
        'username': username,
        'email': email,
      };
}
