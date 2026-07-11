import 'package:json_annotation/json_annotation.dart';

part 'analyze_dashboard_request.g.dart';

/// Outbound request payload for `POST /api/v1/dashboard-assistant`.
///
/// A serialization-only boundary carrying the target [companyId] and an optional
/// free-text [question]. Marked outbound-only via `createFactory: false`, so
/// only the generated `toJson` schema is emitted. The keys are snake_case
/// (`company_id`, `question`) to match the backend's `AnalyzeDashboardRequest`.
@JsonSerializable(createFactory: false)
class AnalyzeDashboardRequest {
  /// Creates an immutable [AnalyzeDashboardRequest].
  const AnalyzeDashboardRequest({
    required this.companyId,
    this.question,
  });

  /// Identifier of the company to analyze; must reference an existing company.
  @JsonKey(name: 'company_id')
  final int companyId;

  /// Optional steering question. When omitted, the assistant runs a general
  /// climate diagnosis. Serialized only when non-null so a blank question is
  /// sent as an absent key rather than an explicit `null`.
  @JsonKey(name: 'question', includeIfNull: false)
  final String? question;

  /// Serializes this request into a JSON-compatible map via the generated
  /// schema.
  Map<String, dynamic> toJson() => _$AnalyzeDashboardRequestToJson(this);
}
