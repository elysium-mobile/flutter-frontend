import 'package:flutter/material.dart';

import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/climate_metrics.dart';
import '../../domain/models/climate_status.dart';

/// Reusable presentation of a full AI climate report [ClimateDiagnosis].
///
/// Renders the deterministic status banner, the AI markdown analysis and the
/// metrics card (scalar pills + per-area report/forum expansions). Shared by the
/// AI Climate Assistant screen and the HR Reports "Generate report" detail
/// sheet, so both surfaces render identical report content.
class ClimateReportContent extends StatelessWidget {
  /// Creates a [ClimateReportContent] for [diagnosis].
  const ClimateReportContent({super.key, required this.diagnosis});

  /// The resolved diagnosis to render.
  final ClimateDiagnosis diagnosis;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _StatusBanner(status: diagnosis.status),
        const SizedBox(height: AppSpacing.md),
        _AnalysisPanel(analysis: diagnosis.analysis),
        const SizedBox(height: AppSpacing.md),
        _MetricsCard(metrics: diagnosis.metrics),
      ],
    );
  }
}

/// Prominent, high-contrast banner mapping the climate [status] to a color and
/// localized label.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status});

  final ClimateStatus status;

  /// Resolves the high-contrast corporate color for [status].
  Color get _color {
    switch (status) {
      case ClimateStatus.good:
        return AppColors.green;
      case ClimateStatus.regular:
        return AppColors.warning;
      case ClimateStatus.critical:
        return AppColors.danger;
      case ClimateStatus.unknown:
        return AppColors.dark;
    }
  }

  /// Resolves the localized label for [status].
  String get _label {
    switch (status) {
      case ClimateStatus.good:
        return AppStrings.statusGood;
      case ClimateStatus.regular:
        return AppStrings.statusRegular;
      case ClimateStatus.critical:
        return AppStrings.statusCritical;
      case ClimateStatus.unknown:
        return AppStrings.statusUnknown;
    }
  }

  /// Resolves the leading icon for [status].
  IconData get _icon {
    switch (status) {
      case ClimateStatus.good:
        return Icons.sentiment_very_satisfied_rounded;
      case ClimateStatus.regular:
        return Icons.sentiment_neutral_rounded;
      case ClimateStatus.critical:
        return Icons.warning_amber_rounded;
      case ClimateStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Row(
        children: <Widget>[
          Icon(_icon, color: AppColors.accentWhite, size: 32),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _label,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.accentWhite,
            ),
          ),
        ],
      ),
    );
  }
}

/// Titled card wrapping the formatted markdown analysis text.
class _AnalysisPanel extends StatelessWidget {
  const _AnalysisPanel({required this.analysis});

  final String analysis;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.dark.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.analysisTitle, style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          _MarkdownBody(source: analysis),
        ],
      ),
    );
  }
}

/// Minimal, self-contained markdown renderer scoped to the analysis payload.
///
/// The backend `analysis` block is plain markdown limited to numbered/section
/// headings, `-`/`•`/`*` bullet lines, `**bold**` inline spans and blank-line
/// paragraphs. Rather than pull in a discontinued third-party markdown package,
/// this widget renders exactly that subset with SoftWork design tokens. It is
/// deliberately conservative: unrecognized syntax degrades to plain body text.
class _MarkdownBody extends StatelessWidget {
  const _MarkdownBody({required this.source});

  final String source;

  /// Whether [line] opens a section heading (a leading `#` or an enumerated
  /// `1.`/`2.` prefix, optionally wrapped in bold markers).
  static bool _isHeading(String line) {
    if (line.startsWith('#')) return true;
    final RegExp enumerated = RegExp(r'^\d+[.)]\s+');
    return enumerated.hasMatch(line);
  }

  /// Whether [line] is a bullet item.
  static bool _isBullet(String line) {
    return line.startsWith('- ') ||
        line.startsWith('* ') ||
        line.startsWith('• ');
  }

  /// Strips leading heading markers (`#`, `1.`) from [line].
  static String _stripHeadingMarker(String line) {
    final String withoutHash = line.replaceFirst(RegExp(r'^#+\s*'), '');
    return withoutHash.replaceFirst(RegExp(r'^\d+[.)]\s+'), '');
  }

  /// Strips the leading bullet marker from [line].
  static String _stripBulletMarker(String line) {
    return line.replaceFirst(RegExp(r'^[-*•]\s+'), '');
  }

  /// Parses inline `**bold**` spans in [text] into styled [TextSpan]s.
  static List<TextSpan> _inlineSpans(String text, TextStyle baseStyle) {
    final List<TextSpan> spans = <TextSpan>[];
    final RegExp bold = RegExp(r'\*\*(.+?)\*\*');
    int cursor = 0;
    for (final RegExpMatch match in bold.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: AppTypography.bold),
      ));
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> lines = source.split('\n');
    final List<Widget> blocks = <Widget>[];

    for (final String raw in lines) {
      final String line = raw.trim();
      if (line.isEmpty) {
        blocks.add(const SizedBox(height: AppSpacing.xs));
        continue;
      }
      if (_isHeading(line)) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(
            _stripHeadingMarker(line).replaceAll('**', ''),
            style: AppTypography.label.copyWith(color: AppColors.primaryNavy),
          ),
        ));
        continue;
      }
      if (_isBullet(line)) {
        blocks.add(Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('•  ', style: AppTypography.body),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTypography.body,
                    children: _inlineSpans(
                      _stripBulletMarker(line),
                      AppTypography.body,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
        continue;
      }
      blocks.add(Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
        child: Text.rich(
          TextSpan(
            style: AppTypography.body,
            children: _inlineSpans(line, AppTypography.body),
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }
}

/// Titled card presenting the scalar metric pills and the per-area expansions.
class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final ClimateMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.dark.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(AppStrings.metricsTitle, style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              _MetricPill(
                label: AppStrings.metricAveragePerformance,
                value: '${metrics.averagePerformance.toStringAsFixed(2)}/5',
              ),
              _MetricPill(
                label: AppStrings.metricEvaluations,
                value: '${metrics.totalEvaluations}',
              ),
              _MetricPill(
                label: AppStrings.metricPositiveSurveyRate,
                value: '${metrics.positiveSurveyRate.round()}%',
              ),
              _MetricPill(
                label: AppStrings.metricSurveyAnswers,
                value: '${metrics.totalSurveyAnswers}',
              ),
              _MetricPill(
                label: AppStrings.metricReports,
                value: '${metrics.totalReports}',
              ),
              _MetricPill(
                label: AppStrings.metricForumMessages,
                value: '${metrics.totalForumMessages}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _ReportsByAreaExpansion(reports: metrics.reportsByArea),
          _ForumActivityByAreaExpansion(
            activity: metrics.forumActivityByArea,
          ),
        ],
      ),
    );
  }
}

/// Single label/value metric pill.
class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentWhite,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: AppTypography.label.copyWith(color: AppColors.primaryNavy),
          ),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.dark.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expansion listing the per-area report tallies.
class _ReportsByAreaExpansion extends StatelessWidget {
  const _ReportsByAreaExpansion({required this.reports});

  final List<AreaReport> reports;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const SizedBox.shrink();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.xs),
        title: Text(
          AppStrings.reportsByAreaTitle,
          style: AppTypography.body.copyWith(fontWeight: AppTypography.semiBold),
        ),
        children: <Widget>[
          for (final AreaReport report in reports)
            _AreaRow(
              areaName: report.areaName,
              detail: '${report.reportCount} ${AppStrings.reportsCountNoun}',
            ),
        ],
      ),
    );
  }
}

/// Expansion listing the per-area forum-activity tallies.
class _ForumActivityByAreaExpansion extends StatelessWidget {
  const _ForumActivityByAreaExpansion({required this.activity});

  final List<AreaForumActivity> activity;

  @override
  Widget build(BuildContext context) {
    if (activity.isEmpty) return const SizedBox.shrink();
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.xs),
        title: Text(
          AppStrings.forumActivityByAreaTitle,
          style: AppTypography.body.copyWith(fontWeight: AppTypography.semiBold),
        ),
        children: <Widget>[
          for (final AreaForumActivity item in activity)
            _AreaRow(
              areaName: item.areaName,
              detail: '${item.threadCount} ${AppStrings.threadsCountNoun}'
                  ' · ${item.messageCount} ${AppStrings.messagesCountNoun}',
            ),
        ],
      ),
    );
  }
}

/// Single area name / detail row rendered inside a per-area expansion.
class _AreaRow extends StatelessWidget {
  const _AreaRow({required this.areaName, required this.detail});

  final String areaName;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(areaName, style: AppTypography.body)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            detail,
            style: AppTypography.caption.copyWith(
              color: AppColors.dark.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
