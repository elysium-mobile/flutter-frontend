import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/presentation/components/gradient_button.dart';
import '../../../shared/presentation/design/app_colors.dart';
import '../../../shared/presentation/design/app_dimensions.dart';
import '../../../shared/presentation/design/app_typography.dart';
import '../../../shared/presentation/i18n/app_strings.dart';
import '../../application/bloc/hr_reports_bloc.dart';
import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/climate_metrics.dart';
import '../../domain/models/company.dart';
import '../components/climate_report_content.dart';
import '../navigation/dashboard_routes.dart';

/// HR Analytics ("Reports") panel — the fourth tab of the authenticated shell.
///
/// Company-level analytics: it renders the "Choose company" selector
/// permanently, and mounts the quad-metrics canvas only while a concrete company
/// is selected. The metrics are the real aggregated values returned by the RRHH
/// `dashboard-assistant` endpoint (average performance, positive-survey rate,
/// total reports, forum activity). Choosing the neutral "None" option collapses
/// the lower section. All state is owned by [HrReportsBloc].
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
        actions: <Widget>[
          IconButton(
            tooltip: AppStrings.aiAssistantEntry,
            icon: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryNavy,
            ),
            onPressed: () =>
                context.pushNamed(DashboardRoutes.aiAssistantName),
          ),
        ],
      ),
      body: BlocConsumer<HrReportsBloc, HrReportsState>(
        // Surface a failed generation once, as a snackbar; the loading modal is
        // driven separately by [HrReportsState.isLoadingMetrics].
        listenWhen: (HrReportsState previous, HrReportsState current) =>
            previous.status != current.status &&
            current.status == HrReportsStatus.failure,
        listener: (BuildContext context, HrReportsState state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: AppColors.danger,
                content: Text(_readableError(state.errorMessage)),
              ),
            );
        },
        buildWhen: (HrReportsState previous, HrReportsState current) =>
            previous.status != current.status ||
            previous.companies != current.companies ||
            previous.selectedCompany != current.selectedCompany ||
            previous.metrics != current.metrics,
        builder: (BuildContext context, HrReportsState state) {
          if (state.status == HrReportsStatus.loadingCompanies) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == HrReportsStatus.failure &&
              state.companies.isEmpty) {
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
          return Stack(
            children: <Widget>[
              _ReportsBody(state: state),
              if (state.isLoadingMetrics) const _LoadingModal(),
            ],
          );
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
    if (state.companies.isEmpty) {
      return Center(
        child: Text(AppStrings.noCompaniesAvailable,
            style: AppTypography.subtitle),
      );
    }

    final Company? selectedCompany = state.selectedCompany;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _CompanySelector(
            companies: state.companies,
            selectedCompany: selectedCompany,
            onSelected: (Company company) => context
                .read<HrReportsBloc>()
                .add(HrReportsCompanySelected(company)),
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
            child: selectedCompany == null
                ? const SizedBox.shrink(key: ValueKey<String>('none'))
                : _MetricsCanvas(
                    key: ValueKey<String>(selectedCompany.id.value),
                    metrics: state.metrics,
                    isLoading: state.isLoadingMetrics,
                    // Enabled only once a diagnosis is loaded; opens the full
                    // report with no extra network call.
                    onGenerate: state.diagnosis == null
                        ? null
                        : () => _showReportSheet(context, state.diagnosis!),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Metrics canvas mounted only while a concrete company is selected.
class _MetricsCanvas extends StatelessWidget {
  const _MetricsCanvas({
    super.key,
    required this.metrics,
    required this.isLoading,
    required this.onGenerate,
  });

  final ClimateMetrics metrics;
  final bool isLoading;

  /// Opens the full report; `null` disables the button until a diagnosis loads.
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.lg),
        _QuadMetricsPanel(metrics: metrics, isLoading: isLoading),
        const SizedBox(height: AppSpacing.lg),
        GradientButton(
          label: AppStrings.generateReport,
          onPressed: onGenerate,
        ),
      ],
    );
  }
}

/// Stylized "Choose company" dropdown selector.
///
/// Presents the neutral "None" entry followed by every company; the null value
/// maps to "None" and collapses the metrics canvas.
class _CompanySelector extends StatelessWidget {
  const _CompanySelector({
    required this.companies,
    required this.selectedCompany,
    required this.onSelected,
    required this.onCleared,
  });

  final List<Company> companies;
  final Company? selectedCompany;
  final ValueChanged<Company> onSelected;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.chooseCompany,
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
            child: DropdownButton<Company?>(
              value: selectedCompany,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primaryNavy,
              ),
              style: AppTypography.input,
              borderRadius: BorderRadius.circular(AppRadii.input),
              items: <DropdownMenuItem<Company?>>[
                DropdownMenuItem<Company?>(
                  value: null,
                  child: Text(AppStrings.noneOption, style: AppTypography.input),
                ),
                for (final Company company in companies)
                  DropdownMenuItem<Company?>(
                    value: company,
                    child: Text(company.name, style: AppTypography.input),
                  ),
              ],
              onChanged: (Company? company) {
                if (company == null) {
                  onCleared();
                } else {
                  onSelected(company);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Two-by-two grid of high-contrast metric boxes fed by the company's aggregated
/// [ClimateMetrics].
class _QuadMetricsPanel extends StatelessWidget {
  const _QuadMetricsPanel({required this.metrics, required this.isLoading});

  final ClimateMetrics metrics;
  final bool isLoading;

  /// Formats the 0..5 average-performance score as a whole percentage.
  static String _performancePercent(double score) =>
      '${(score / 5 * 100).round()}%';

  /// Formats a 0..100 rate as a whole percentage.
  static String _ratePercent(double rate) => '${rate.round()}%';

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
                  value: _performancePercent(metrics.averagePerformance),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricBox(
                  color: AppColors.purple,
                  icon: Icons.assignment_rounded,
                  label: AppStrings.completedSurveys,
                  value: _ratePercent(metrics.positiveSurveyRate),
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
                  value: '${metrics.totalReports}',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetricBox(
                  color: AppColors.green,
                  icon: Icons.forum_rounded,
                  label: AppStrings.metricForumMessages,
                  value: '${metrics.totalForumMessages}',
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

/// Full-screen modal loading overlay shown while a company's report is being
/// generated (the RRHH climate diagnosis runs an AI aggregation server-side).
///
/// A dismiss-blocking [ModalBarrier] absorbs input while a centered card shows a
/// spinner and a localized caption, so the metrics only appear once ready.
class _LoadingModal extends StatelessWidget {
  const _LoadingModal();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          const ModalBarrier(dismissible: false, color: Colors.black45),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.generatingReport,
                    style: AppTypography.label,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Presents the specific backend failure when available, stripping the leading
/// `Exception:` noise, and falls back to the generic message.
String _readableError(String? raw) {
  if (raw == null || raw.trim().isEmpty) return AppStrings.somethingWentWrong;
  return raw.replaceFirst(RegExp(r'^Exception:\s*'), '').trim();
}

/// Opens the full climate report for [diagnosis] as a scrollable modal sheet.
///
/// Reuses the already-loaded diagnosis (no additional network call) and renders
/// the shared [ClimateReportContent] — status verdict, AI analysis and per-area
/// breakdowns — that the summary tiles cannot show.
Future<void> _showReportSheet(BuildContext context, ClimateDiagnosis diagnosis) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.card)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (BuildContext context, ScrollController scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.dark.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ClimateReportContent(diagnosis: diagnosis),
              ],
            ),
          );
        },
      );
    },
  );
}
