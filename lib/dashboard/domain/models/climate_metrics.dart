/// Per-area report tally contained in the climate diagnosis metrics.
///
/// Pure by construction (no serialization or infrastructure imports), with
/// hand-written value equality. Sourced from the backend's raw `reportsByArea`
/// list, whose item keys (`areaId`, `areaName`, `reportCount`) remain camelCase
/// — the mapping into this entity happens entirely in the data layer.
class AreaReport {
  /// Creates an immutable [AreaReport].
  const AreaReport({
    required this.areaId,
    required this.areaName,
    required this.reportCount,
  });

  /// Identifier of the functional area.
  final int areaId;

  /// Human-readable name of the area.
  final String areaName;

  /// Number of reports raised within the area.
  final int reportCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AreaReport &&
        other.areaId == areaId &&
        other.areaName == areaName &&
        other.reportCount == reportCount;
  }

  @override
  int get hashCode => Object.hash(areaId, areaName, reportCount);
}

/// Per-area forum-activity tally contained in the climate diagnosis metrics.
///
/// Pure value object mirroring the backend's raw `forumActivityByArea` list
/// items (`areaId`, `areaName`, `threadCount`, `messageCount`).
class AreaForumActivity {
  /// Creates an immutable [AreaForumActivity].
  const AreaForumActivity({
    required this.areaId,
    required this.areaName,
    required this.threadCount,
    required this.messageCount,
  });

  /// Identifier of the functional area.
  final int areaId;

  /// Human-readable name of the area.
  final String areaName;

  /// Number of forum threads opened within the area.
  final int threadCount;

  /// Number of forum messages posted within the area.
  final int messageCount;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AreaForumActivity &&
        other.areaId == areaId &&
        other.areaName == areaName &&
        other.threadCount == threadCount &&
        other.messageCount == messageCount;
  }

  @override
  int get hashCode =>
      Object.hash(areaId, areaName, threadCount, messageCount);
}

/// Immutable snapshot of the raw metrics backing an AI climate diagnosis.
///
/// These values originate from the backend's un-mapped `metrics`
/// `Map<String, Object>`, whose keys stay strictly camelCase (Jackson's
/// snake_case strategy rewrites declared bean properties only, never runtime
/// `Map` keys). The camelCase extraction is confined to the data-layer mapper;
/// this domain entity is pure and exposes only typed fields.
class ClimateMetrics {
  /// Creates an immutable [ClimateMetrics].
  const ClimateMetrics({
    required this.averagePerformance,
    required this.totalEvaluations,
    required this.positiveSurveyRate,
    required this.totalSurveyAnswers,
    required this.totalReports,
    required this.reportsByArea,
    required this.totalForumMessages,
    required this.forumActivityByArea,
  });

  /// Creates a zeroed [ClimateMetrics] with empty per-area breakdowns.
  ///
  /// Used as the truthful neutral value when the backend omits the metrics
  /// block entirely.
  const ClimateMetrics.empty()
      : averagePerformance = 0,
        totalEvaluations = 0,
        positiveSurveyRate = 0,
        totalSurveyAnswers = 0,
        totalReports = 0,
        reportsByArea = const <AreaReport>[],
        totalForumMessages = 0,
        forumActivityByArea = const <AreaForumActivity>[];

  /// Average performance score (from `averagePerformance`), on the backend's
  /// 0..5 scale.
  final double averagePerformance;

  /// Number of performance evaluations aggregated (`totalEvaluations`).
  final int totalEvaluations;

  /// Positive-survey rate percentage (`positiveSurveyRate`), 0..100.
  final double positiveSurveyRate;

  /// Number of survey answers aggregated (`totalSurveyAnswers`).
  final int totalSurveyAnswers;

  /// Total number of reports across all areas (`totalReports`).
  final int totalReports;

  /// Per-area report breakdown (`reportsByArea`).
  final List<AreaReport> reportsByArea;

  /// Total number of forum messages across all areas (`totalForumMessages`).
  final int totalForumMessages;

  /// Per-area forum-activity breakdown (`forumActivityByArea`).
  final List<AreaForumActivity> forumActivityByArea;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClimateMetrics &&
        other.averagePerformance == averagePerformance &&
        other.totalEvaluations == totalEvaluations &&
        other.positiveSurveyRate == positiveSurveyRate &&
        other.totalSurveyAnswers == totalSurveyAnswers &&
        other.totalReports == totalReports &&
        other.totalForumMessages == totalForumMessages &&
        _sameReports(other.reportsByArea, reportsByArea) &&
        _sameForum(other.forumActivityByArea, forumActivityByArea);
  }

  @override
  int get hashCode => Object.hash(
        averagePerformance,
        totalEvaluations,
        positiveSurveyRate,
        totalSurveyAnswers,
        totalReports,
        totalForumMessages,
        Object.hashAll(reportsByArea),
        Object.hashAll(forumActivityByArea),
      );

  /// Order-sensitive structural comparison of two report breakdowns.
  static bool _sameReports(List<AreaReport> a, List<AreaReport> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  /// Order-sensitive structural comparison of two forum-activity breakdowns.
  static bool _sameForum(List<AreaForumActivity> a, List<AreaForumActivity> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
