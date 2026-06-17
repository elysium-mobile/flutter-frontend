import 'package:json_annotation/json_annotation.dart';

/// Request payload exchanging a verified identity-provider token for a
/// first-party SoftWork session.
///
/// The client authenticates against Firebase/Google, obtains a trusted Firebase
/// ID token, and forwards it here so the backend can mint its own session — the
/// credential-bridging workflow.
@JsonSerializable()
class SignInRequest {
  /// Creates a [SignInRequest] from a Firebase [idToken].
  const SignInRequest({required this.idToken});

  /// Short-lived Firebase ID token proving the caller's verified identity.
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Serializes this request into a JSON-compatible map.
  Map<String, dynamic> toJson() => <String, dynamic>{'id_token': idToken};
}
