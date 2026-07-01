import 'package:json_annotation/json_annotation.dart';

part 'sign_in_request.g.dart';

/// Outbound request payload exchanging a verified identity-provider token for a
/// first-party SoftWork session.
///
/// A serialization-only boundary: the client authenticates against
/// Firebase/Google, obtains a trusted Firebase ID token, and forwards it here so
/// the backend can mint its own session. Marked outbound-only via
/// `createFactory: false`, so only the generated `toJson` schema is emitted.
@JsonSerializable(createFactory: false)
class SignInRequest {
  /// Creates an immutable [SignInRequest] from a Firebase [idToken].
  const SignInRequest({required this.idToken});

  /// Short-lived Firebase ID token proving the caller's verified identity.
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Serializes this request into a JSON-compatible map via the generated
  /// schema.
  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}
