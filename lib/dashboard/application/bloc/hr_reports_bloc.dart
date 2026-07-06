import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/team_metrics.dart';
import '../../domain/models/work_team.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'hr_reports_event.dart';
part 'hr_reports_state.dart';

/// Unified Business Logic Component orchestrating the HR Analytics ("Reports")
/// screen.
///
/// It owns two coupled concerns behind a single state machine: loading the
/// assigned work teams that populate the "Choose team" selector, and loading the
/// [TeamMetrics] for whichever team is currently selected. UI intents are the
/// only inputs; no navigation or widget concern leaks in here — the presentation
/// layer reacts to [HrReportsStatus].
class HrReportsBloc extends Bloc<HrReportsEvent, HrReportsState> {
  /// Creates an [HrReportsBloc] bound to the [DashboardRepository] port.
  HrReportsBloc({required DashboardRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const HrReportsState()) {
    on<HrReportsStarted>(_onStarted);
    on<HrReportsTeamSelected>(_onTeamSelected);
    on<HrReportsReportRequested>(_onReportRequested);
  }

  final DashboardRepository _repository;

  /// Loads the assigned teams and, when present, auto-selects the first one so
  /// the metrics panel is never empty on entry.
  Future<void> _onStarted(
    HrReportsStarted event,
    Emitter<HrReportsState> emit,
  ) async {
    emit(state.copyWith(status: HrReportsStatus.loadingTeams, errorMessage: null));
    try {
      final teams = await _repository.loadAssignedTeams();
      if (teams.isEmpty) {
        emit(state.copyWith(status: HrReportsStatus.ready, teams: teams));
        return;
      }
      emit(state.copyWith(status: HrReportsStatus.ready, teams: teams));
      add(HrReportsTeamSelected(teams.first));
    } catch (error) {
      emit(state.copyWith(
        status: HrReportsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Loads the metrics for the newly selected [WorkTeam].
  Future<void> _onTeamSelected(
    HrReportsTeamSelected event,
    Emitter<HrReportsState> emit,
  ) async {
    emit(state.copyWith(
      status: HrReportsStatus.loadingMetrics,
      selectedTeam: event.team,
      errorMessage: null,
    ));
    try {
      final metrics = await _repository.loadTeamMetrics(event.team.id);
      emit(state.copyWith(status: HrReportsStatus.ready, metrics: metrics));
    } catch (error) {
      emit(state.copyWith(
        status: HrReportsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Handles the "Generate report" footer action.
  ///
  /// Report export is not part of the current backend contract, so this only
  /// flags a transient acknowledgement the view can surface; no fabricated
  /// artifact is produced.
  void _onReportRequested(
    HrReportsReportRequested event,
    Emitter<HrReportsState> emit,
  ) {
    emit(state.copyWith(reportRequestedAt: DateTime.now()));
  }
}
