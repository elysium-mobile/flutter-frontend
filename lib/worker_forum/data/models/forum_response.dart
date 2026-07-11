import 'package:json_annotation/json_annotation.dart';

import 'category_response.dart';

part 'forum_response.g.dart';

/// Inbound network contract for a `ForumResponse` returned by
/// `GET /api/v1/forums/company/{companyId}`.
///
/// Carries the nested `categories` (each with its threads and messages); the
/// forum's own metadata is intentionally omitted since the RRHH view presents a
/// flat thread list. Marked inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class ForumResponse {
  /// Creates a [ForumResponse] from its explicit wire fields.
  const ForumResponse({
    required this.forumId,
    required this.categories,
  });

  /// Server-driven unique identifier of the forum.
  @JsonKey(name: 'forum_id')
  final int forumId;

  /// Nested categories (`categories`); empty when absent.
  @JsonKey(name: 'categories', defaultValue: <CategoryResponse>[])
  final List<CategoryResponse> categories;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory ForumResponse.fromJson(Map<String, dynamic> json) =>
      _$ForumResponseFromJson(json);
}
