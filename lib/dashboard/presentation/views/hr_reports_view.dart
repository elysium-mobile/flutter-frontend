import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/hr_reports_bloc.dart';
import '../../domain/models/metric_point.dart';
import '../../domain/models/team_metrics.dart';
import '../../domain/models/work_team.dart';

/// HR Analytics ("Reportes") panel — the fourth tab of the authenticated shell.
///
/// The layout is strictly state-driven: it renders the "Elegir equipo" selector
/// permanently, and mounts the metrics canvas (quad panel, historical chart and
/// action footer) only while a concrete team is selected. Choosing the neutral
/// "Ninguno" option collapses the entire lower section out of the widget tree.
/// All state is owned by [HrReportsBloc]; this view holds no business logic.
class HrReportsView extends StatelessWidget {
  /// Creates an [HrReportsView].
  const HrReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(AppStrings.hrReportsTitle, style: AppTypography.title),
      ),
      body: BlocConsumer<HrReportsBloc, HrReportsState>(
        listenWhen: (previous, current) =>
            previous.reportRequestedAt != current.reportRequestedAt &&
            current.reportRequestedAt != null,
        listener: (BuildContext context, HrReportsState state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(AppStrings.reportRequested)),
            );
        },
        builder: (BuildContext context, HrReportsState state) {
          if (state.status == HrReportsStatus.loadingTeams) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HrReportsStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  AppStrings.somethingWentWrong,
                  textAlign: TextAlign.center,
                  style: AppTypography.subtitle,
                ),
              ),
            );
          }
          return _ReportsBody(state: state);
        },
      ),
    );
  }
}

/// Scrollable content column: the always-present selector plus the reactively
/// mounted metrics canvas.
class _ReportsBody extends StatelessWidget {
  const _ReportsBody({required this.state});

  final HrReportsState state;

  @override
  Widget build(BuildContext context) {
    if (state.teams.isEmpty) {
      return Center(
        child: Text(AppStrings.noAssignedTeams, style: AppTypography.subtitle),
      );
    }

    final WorkTeam? selectedTeam = state.selectedTeam;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TeamSelector(
            teams: state.teams,
            selectedTeam: selectedTeam,
            onSelected: (WorkTeam team) => context
                .read<HrReportsBloc>()
                .add(HrReportsTeamSelected(team)),
            onCleared: () => context
                .read<HrReportsBloc>()
                .add(const HrReportsSelectionCleared()),
          ),
          // Reactively mounts/collapses the metrics canvas on selection change.
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              );
            },
            child: selectedTeam == null
                ? const SizedBox.shrink(key: ValueKey<String>('none'))
                : _MetricsCanvas(
                    key: ValueKey<String>(selectedTeam.id.value),
                    metrics: state.metrics,
                    isLoading: state.isLoadingMetrics,
                    onGenerate: () => context
                        .read<HrReportsBloc>()
                        .add(const HrReportsReportRequested()),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Comprehensive metrics canvas mounted only while a concrete team is selected.
///
/// Bundles the quad-metrics panel, the historical progress chart and the
/// "Generar reporte" footer button into a single animatable subtree.
class _MetricsCanvas extends StatelessWidget {
  const _MetricsCanvas({
    super.key,
    required this.metrics,
    required this.isLoading,
    required this.onGenerate,
  });

  final TeamMetrics metrics;
  final bool isLoading;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.lg),
        _QuadMetricsPanel(metrics: metrics, isLoading: isLoading),
        const SizedBox(height: AppSpacing.lg),
        _HistoricalProgressChart(history: metrics.history),
        const SizedBox(height: AppSpacing.lg),
        GradientButton(
          label: AppStrings.generateReport,
          onPressed: onGenerate,
        ),
      ],
    );
  }
}

/// Stylized "Elegir equipo" dropdown selector.
///
/// Presents the neutral "Ninguno" entry followed by every assigned team; the
/// null value maps to "Ninguno" and collapses the metrics canvas.
class _TeamSelector extends StatelessWidget {
  const _TeamSelector({
    required this.teams,
    required this.selectedTeam,
    required this.onSelected,
    required this.onCleared,
  });

  final List<WorkTeam> teams;
  final WorkTeam? selectedTeam;
  final ValueChanged<WorkTeam> onSelected;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.chooseTeam,
          style: AppTypography.caption.copyWith(
            color: AppColors.dark.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.accentWhite,
            borderRadius: BorderRadius.circular(AppRadii.input),
            border: Border.all(color: AppColors.mint),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<WorkTeam?>(
              value: selectedTeam,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryNavy,
              ),
              style: AppTypography.input,
              borderRadius: BorderRadius.circular(AppRadii.input),
              items: <DropdownMenuItem<WorkTeam?>>[
                DropdownMenuItem<WorkTeam?>(
                  value: null,
                  child: Text(AppStrings.noneOption, style: AppTypography.input),
                ),
                for (final WorkTeam team in teams)
                  DropdownMenuItem<WorkTeam?>(
                    value: team,
                    child: Text(team.teamName, style: AppTypography.input),
                  ),
              ],
              onChanged: (WorkTeam? team) {
                if (team == null) {
                  onCleared();
                } else {
                  onSelected(team);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Two-by-two grid of high-contrast metric boxes mirroring the design blueprint.
class _QuadMetricsPanel extends StatelessWidget {
  const _QuadMetricsPanel({required this.metrics, required this.isLoading});

  final TeamMetrics metrics;
  final bool isLoading;

  /// Formats a normalized `0.0..1.0` ratio as a whole-percentage string.
  static String _percent(double ratio) => '${(ratio * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading ? 0.4 : 1,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricBox(
                  color: AppColors.teal,
                  icon: Icons.favorite_rounded,
                  label: AppStrings.averageWellbeing,
                  value: _percent(metrics.averageWellbeing),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricBox(
                  color: AppColors.green,
                  icon: Icons.groups_rounded,
                  label: AppStrings.members,
                  value: '${metrics.memberCount}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetricBox(
                  color: AppColors.danger,
                  icon: Icons.priority_high_rounded,
                  label: AppStrings.forumReports,
                  value: '${metrics.forumReportCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricBox(
                  color: AppColors.purple,
                  icon: Icons.assignment_rounded,
                  label: AppStrings.completedSurveys,
                  value: _percent(metrics.completedSurveys),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single colored metric container rendering an icon, a headline value and a
/// caption label.
class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.accentWhite, size: 28),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.displayLarge.copyWith(
              color: AppColors.accentWhite,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.accentWhite,
            ),
          ),
        ],
      ),
    );
  }
}

/// Historical progress line chart wrapped in a titled card.
class _HistoricalProgressChart extends StatelessWidget {
  const _HistoricalProgressChart({required this.history});

  final List<MetricPoint> history;

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
          Text(AppStrings.historicalProgress, style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: history.length < 2
                ? Center(
                    child: Text(
                      AppStrings.noHistoryData,
                      style: AppTypography.subtitle,
                    ),
                  )
                : CustomPaint(
                    painter: _LineChartPainter(history: history),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter plotting the [history] series as a filled line chart.
///
/// The horizontal axis maps sample index to width; the vertical axis maps the
/// sample value onto the drawable height, normalized between the series' minimum
/// and maximum so the trend fills the available space.
class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.history});

  final List<MetricPoint> history;

  @override
  void paint(Canvas canvas, Size size) {
    final double minValue =
        history.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final double maxValue =
        history.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final double span = (maxValue - minValue).abs() < 1e-9
        ? 1
        : (maxValue - minValue);

    final List<Offset> points = <Offset>[
      for (int i = 0; i < history.length; i++)
        Offset(
          size.width * (i / (history.length - 1)),
          size.height * (1 - (history[i].value - minValue) / span),
        ),
    ];

    // Baseline axis.
    final Paint axisPaint = Paint()
      ..color = AppColors.dark.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );

    // Line path across the data nodes.
    final Path linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final Offset point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    // Soft fill beneath the line.
    final Path fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    final Paint fillPaint = Paint()
      ..color = AppColors.sky.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = AppColors.sky
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // Data-node markers.
    final Paint nodePaint = Paint()..color = AppColors.teal;
    for (final Offset point in points) {
      canvas.drawCircle(point, 3.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.history != history;
}
