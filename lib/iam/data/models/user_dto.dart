import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/user.dart';

/// Data Transfer Object mirroring the wire representation of a user.
///
/// Serialization intent is declared with `json_annotation` metadata; the
/// `fromJson`/`toJson` bodies are explicit so the data layer needs no generated
/// part. Domain mapping happens only in [toDomain], so the pure `domain/` layer
/// never sees a transport type.
@JsonSerializable()
class UserDto {
  /// Creates a [UserDto].
  const UserDto({
    required this.id,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  /// Backend identifier of the user.
  @JsonKey(name: 'id')
  final String id;

  /// Display name of the user.
  @JsonKey(name: 'username')
  final String username;

  /// Institutional email address of the user.
  @JsonKey(name: 'email')
  final String email;

  /// Optional remote avatar URL.
  @JsonKey(name: 'photo_url')
  final String? photoUrl;

  /// Builds a [UserDto] from a decoded JSON [json] map.
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String?,
    );
  }

  /// Serializes this DTO into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'photo_url': photoUrl,
    };
  }

  /// Projects this DTO onto the pure-domain [User] entity, wrapping the raw id
  /// in the shared [Id] value object.
  User toDomain() {
    return User(
      id: Id(id),
      username: username,
      email: email,
      photoUrl: photoUrl,
    );
  }
}
