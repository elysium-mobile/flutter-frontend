import 'climate_metrics.dart';
import 'climate_status.dart';

/// Immutable result of an AI climate diagnosis for a company.
///
/// Aggregates the deterministic [status] verdict, the AI-generated [analysis]
/// narrative (a markdown block, always authored in Spanish by the backend), and
/// the raw [metrics] that fed the analysis. Pure by construction with
/// hand-written value equality; the transport → domain projection lives in the
/// data layer.
class ClimateDiagnosis {
  /// Creates an immutable [ClimateDiagnosis].
  const ClimateDiagnosis({
    required this.status,
    required this.analysis,
    required this.metrics,
  });

  /// Deterministic climate verdict computed from the metric thresholds.
  final ClimateStatus status;

  /// AI-generated explanation and recommendations, formatted as markdown.
  final String analysis;

  /// Raw metrics used to build the analysis.
  final ClimateMetrics metrics;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClimateDiagnosis &&
        other.status == status &&
        other.analysis == analysis &&
        other.metrics == metrics;
  }

  @override
  int get hashCode => Object.hash(status, analysis, metrics);
}
