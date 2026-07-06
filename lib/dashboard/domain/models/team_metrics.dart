import 'metric_point.dart';

/// Immutable snapshot of the workforce metrics tracked for a single work team.
///
/// Bundles the four headline indicators rendered by the quad-metrics panel plus
/// the chronological [history] series feeding the historical progress chart. The
/// two ratio indicators ([averageWellbeing], [completedSurveys]) are normalized
/// to the `0.0..1.0` range so the presentation layer owns percentage formatting.
///
/// Pure by construction: no annotations, serialization tokens or infrastructure
/// imports, with hand-written value equality.
class TeamMetrics {
  /// Creates an immutable [TeamMetrics].
  const TeamMetrics({
    required this.averageWellbeing,
    required this.memberCount,
    required this.forumReportCount,
    required this.completedSurveys,
    required this.history,
  });

  /// Creates a zeroed [TeamMetrics] with an empty [history].
  ///
  /// Used as the truthful neutral value while no team is selected and as the
  /// baseline the repository returns until the backend exposes an aggregate
  /// team-metrics endpoint (a documented integration gap).
  const TeamMetrics.empty()
      : averageWellbeing = 0,
        memberCount = 0,
        forumReportCount = 0,
        completedSurveys = 0,
        history = const <MetricPoint>[];

  /// Average wellbeing ratio across the team, normalized to `0.0..1.0`.
  final double averageWellbeing;

  /// Number of active members currently belonging to the team.
  final int memberCount;

  /// Number of open forum reports raised against the team.
  final int forumReportCount;

  /// Completed-surveys ratio for the team, normalized to `0.0..1.0`.
  final double completedSurveys;

  /// Chronological samples driving the historical progress chart.
  final List<MetricPoint> history;

  /// Returns a copy of this [TeamMetrics] overriding only the provided fields.
  TeamMetrics copyWith({
    double? averageWellbeing,
    int? memberCount,
    int? forumReportCount,
    double? completedSurveys,
    List<MetricPoint>? history,
  }) {
    return TeamMetrics(
      averageWellbeing: averageWellbeing ?? this.averageWellbeing,
      memberCount: memberCount ?? this.memberCount,
      forumReportCount: forumReportCount ?? this.forumReportCount,
      completedSurveys: completedSurveys ?? this.completedSurveys,
      history: history ?? this.history,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamMetrics &&
        other.averageWellbeing == averageWellbeing &&
        other.memberCount == memberCount &&
        other.forumReportCount == forumReportCount &&
        other.completedSurveys == completedSurveys &&
        _sameHistory(other.history, history);
  }

  @override
  int get hashCode => Object.hash(
        averageWellbeing,
        memberCount,
        forumReportCount,
        completedSurveys,
        Object.hashAll(history),
      );

  /// Structural comparison of two metric series (order-sensitive).
  static bool _sameHistory(List<MetricPoint> a, List<MetricPoint> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'TeamMetrics(averageWellbeing: $averageWellbeing, '
      'memberCount: $memberCount, forumReportCount: $forumReportCount, '
      'completedSurveys: $completedSurveys, history: ${history.length} points)';
}
