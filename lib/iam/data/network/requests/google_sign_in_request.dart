import 'package:json_annotation/json_annotation.dart';

part 'google_sign_in_request.g.dart';

/// Outbound request payload for `POST /api/v1/authentication/google`
/// (`GoogleSignInRequest`).
///
/// Carries the Google Identity Services [idToken] (audience =
/// `GOOGLE_OAUTH_CLIENT`) so the backend can validate it and report whether an
/// account already exists. A serialization-only boundary marked outbound-only
/// via `createFactory: false`.
@JsonSerializable(createFactory: false)
class GoogleSignInRequest {
  /// Creates an immutable [GoogleSignInRequest] from a Google [idToken].
  const GoogleSignInRequest({required this.idToken});

  /// The Google Identity Services ID token, validated server-side.
  @JsonKey(name: 'id_token')
  final String idToken;

  /// Serializes this request via the generated schema.
  Map<String, dynamic> toJson() => _$GoogleSignInRequestToJson(this);
}
