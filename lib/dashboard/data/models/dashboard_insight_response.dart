import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/climate_metrics.dart';
import '../../domain/models/climate_status.dart';

part 'dashboard_insight_response.g.dart';

/// Inbound network contract for the AI climate diagnosis returned by
/// `POST /api/v1/dashboard-assistant` (`DashboardInsightResponse`).
///
/// The three top-level keys (`status`, `analysis`, `metrics`) are snake_case —
/// they are single words, so the backend's `@JsonNaming(SnakeCaseStrategy)`
/// leaves them unchanged. Deserialization of these declared fields is delegated
/// to the generated schema; the projection into the pure domain layer is exposed
/// through [toDomain].
///
/// ⚠️ The [metrics] value is a raw `Map<String, dynamic>` deliberately left
/// un-mapped: it is a runtime Java `Map<String, Object>`, so every key inside it
/// (and inside its nested list items) stays **camelCase** exactly as authored on
/// the server. The camelCase extraction is quarantined in this data-layer
/// adapter — see [_metricsToDomain] — so the domain never sees a transport key.
@JsonSerializable(createToJson: false)
class DashboardInsightResponse {
  /// Creates a [DashboardInsightResponse] from its explicit wire fields.
  const DashboardInsightResponse({
    required this.status,
    required this.analysis,
    required this.metrics,
  });

  /// Deterministic status token: one of `"BUENO"`, `"REGULAR"`, `"CRITICO"`.
  @JsonKey(name: 'status')
  final String status;

  /// AI-generated markdown analysis and recommendations (Spanish).
  @JsonKey(name: 'analysis')
  final String analysis;

  /// Raw, un-mapped metrics map with **camelCase** inner keys (may be absent).
  @JsonKey(name: 'metrics')
  final Map<String, dynamic>? metrics;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory DashboardInsightResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardInsightResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [ClimateDiagnosis],
  /// resolving the status token and extracting the camelCase metrics map.
  ClimateDiagnosis toDomain() {
    return ClimateDiagnosis(
      status: ClimateStatus.fromWire(status),
      analysis: analysis,
      metrics: _metricsToDomain(metrics),
    );
  }

  /// Maps the raw, camelCase-keyed metrics map onto the typed [ClimateMetrics].
  ///
  /// Reads each inner key exactly as the backend emits it (`averagePerformance`,
  /// `totalEvaluations`, `positiveSurveyRate`, `totalSurveyAnswers`,
  /// `totalReports`, `reportsByArea`, `totalForumMessages`,
  /// `forumActivityByArea`), coercing JSON numbers defensively. A null/absent
  /// map yields [ClimateMetrics.empty].
  static ClimateMetrics _metricsToDomain(Map<String, dynamic>? raw) {
    if (raw == null) return const ClimateMetrics.empty();
    return ClimateMetrics(
      averagePerformance: _asDouble(raw['averagePerformance']),
      totalEvaluations: _asInt(raw['totalEvaluations']),
      positiveSurveyRate: _asDouble(raw['positiveSurveyRate']),
      totalSurveyAnswers: _asInt(raw['totalSurveyAnswers']),
      totalReports: _asInt(raw['totalReports']),
      reportsByArea: _asList(raw['reportsByArea'])
          .map((Map<String, dynamic> e) => AreaReport(
                areaId: _asInt(e['areaId']),
                areaName: _asString(e['areaName']),
                reportCount: _asInt(e['reportCount']),
              ))
          .toList(),
      totalForumMessages: _asInt(raw['totalForumMessages']),
      forumActivityByArea: _asList(raw['forumActivityByArea'])
          .map((Map<String, dynamic> e) => AreaForumActivity(
                areaId: _asInt(e['areaId']),
                areaName: _asString(e['areaName']),
                threadCount: _asInt(e['threadCount']),
                messageCount: _asInt(e['messageCount']),
              ))
          .toList(),
    );
  }

  /// Coerces a dynamic JSON number to a `double`, defaulting to `0.0`.
  static double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : 0.0;

  /// Coerces a dynamic JSON number to an `int`, defaulting to `0`.
  static int _asInt(dynamic value) => value is num ? value.toInt() : 0;

  /// Coerces a dynamic JSON value to a `String`, defaulting to empty.
  static String _asString(dynamic value) => value?.toString() ?? '';

  /// Coerces a dynamic JSON value to a list of string-keyed maps, defaulting to
  /// an empty list and skipping any non-object entries.
  static List<Map<String, dynamic>> _asList(dynamic value) {
    if (value is! List) return const <Map<String, dynamic>>[];
    return value.whereType<Map<String, dynamic>>().toList();
  }
}
