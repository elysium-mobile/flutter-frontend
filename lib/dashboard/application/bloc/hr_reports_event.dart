part of 'hr_reports_bloc.dart';

/// Base type for every intent the HR Analytics screen dispatches to
/// [HrReportsBloc].
sealed class HrReportsEvent extends Equatable {
  /// Const constructor for subclasses.
  const HrReportsEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The screen was opened; load the assigned teams.
final class HrReportsStarted extends HrReportsEvent {
  /// Creates an [HrReportsStarted].
  const HrReportsStarted();
}

/// A team was chosen in the "Choose team" selector; load its metrics.
final class HrReportsTeamSelected extends HrReportsEvent {
  /// Creates an [HrReportsTeamSelected].
  const HrReportsTeamSelected(this.team);

  /// The newly selected team.
  final WorkTeam team;

  @override
  List<Object?> get props => <Object?>[team];
}

/// The "Generate report" footer button was pressed.
final class HrReportsReportRequested extends HrReportsEvent {
  /// Creates an [HrReportsReportRequested].
  const HrReportsReportRequested();
}
