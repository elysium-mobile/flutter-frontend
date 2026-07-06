part of 'hr_reports_bloc.dart';

/// Lifecycle status of the HR Analytics flow, decoupled from any UI
/// representation.
enum HrReportsStatus {
  /// Nothing has been requested yet.
  initial,

  /// The assigned teams are being fetched.
  loadingTeams,

  /// Metrics for the selected team are being fetched.
  loadingMetrics,

  /// Teams (and, when a team is selected, its metrics) are available.
  ready,

  /// A load failed; inspect [HrReportsState.errorMessage].
  failure,
}

/// Immutable state of the HR Analytics screen managed by [HrReportsBloc].
final class HrReportsState extends Equatable {
  /// Creates an [HrReportsState].
  const HrReportsState({
    this.status = HrReportsStatus.initial,
    this.teams = const <WorkTeam>[],
    this.selectedTeam,
    this.metrics = const TeamMetrics.empty(),
    this.errorMessage,
    this.reportRequestedAt,
  });

  /// Current lifecycle status of the flow.
  final HrReportsStatus status;

  /// Assigned teams populating the "Choose team" selector.
  final List<WorkTeam> teams;

  /// Currently selected team, or `null` before any selection.
  final WorkTeam? selectedTeam;

  /// Metrics for [selectedTeam]; a zeroed snapshot until one is loaded.
  final TeamMetrics metrics;

  /// Raw diagnostic error message when [status] is [HrReportsStatus.failure].
  final String? errorMessage;

  /// Timestamp of the most recent "Generate report" request, or `null`.
  final DateTime? reportRequestedAt;

  /// Whether the metrics panel should render its loading affordance.
  bool get isLoadingMetrics => status == HrReportsStatus.loadingMetrics;

  /// Returns a copy overriding the provided fields. [selectedTeam],
  /// [errorMessage] and [reportRequestedAt] use a sentinel so they can be
  /// explicitly cleared to `null`.
  HrReportsState copyWith({
    HrReportsStatus? status,
    List<WorkTeam>? teams,
    Object? selectedTeam = _sentinel,
    TeamMetrics? metrics,
    Object? errorMessage = _sentinel,
    Object? reportRequestedAt = _sentinel,
  }) {
    return HrReportsState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      selectedTeam: identical(selectedTeam, _sentinel)
          ? this.selectedTeam
          : selectedTeam as WorkTeam?,
      metrics: metrics ?? this.metrics,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      reportRequestedAt: identical(reportRequestedAt, _sentinel)
          ? this.reportRequestedAt
          : reportRequestedAt as DateTime?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        teams,
        selectedTeam,
        metrics,
        errorMessage,
        reportRequestedAt,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
