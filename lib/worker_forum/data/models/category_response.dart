import 'package:json_annotation/json_annotation.dart';

import 'thread_response.dart';

part 'category_response.g.dart';

/// Inbound network contract for a `CategoryResponse` nested inside a forum.
///
/// Only the nested `threads` are consumed by the read-only aggregation; the
/// category's own metadata is intentionally omitted. Marked inbound-only
/// (`createToJson: false`).
@JsonSerializable(createToJson: false)
class CategoryResponse {
  /// Creates a [CategoryResponse] from its explicit wire fields.
  const CategoryResponse({
    required this.categoryId,
    required this.threads,
  });

  /// Server-driven unique identifier of the category.
  @JsonKey(name: 'category_id')
  final int categoryId;

  /// Nested threads (`threads`); empty when absent.
  @JsonKey(name: 'threads', defaultValue: <ThreadResponse>[])
  final List<ThreadResponse> threads;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}
