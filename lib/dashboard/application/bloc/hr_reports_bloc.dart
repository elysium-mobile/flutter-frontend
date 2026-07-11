import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/climate_metrics.dart';
import '../../domain/models/company.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'hr_reports_event.dart';
part 'hr_reports_state.dart';

/// Business Logic Component orchestrating the HR Analytics ("Reports") screen.
///
/// The screen presents company-level HR metrics: it loads the selectable
/// companies for the "Choose company" selector, then — for the selected company
/// — fetches the aggregated [ClimateMetrics] from the RRHH `dashboard-assistant`
/// endpoint (average performance, positive-survey rate, total reports and forum
/// activity). UI intents are the only inputs; no navigation or widget concern
/// leaks in here — the presentation layer reacts to [HrReportsStatus].
class HrReportsBloc extends Bloc<HrReportsEvent, HrReportsState> {
  /// Creates an [HrReportsBloc] bound to the [DashboardRepository] port.
  HrReportsBloc({required DashboardRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const HrReportsState()) {
    on<HrReportsStarted>(_onStarted);
    on<HrReportsCompanySelected>(_onCompanySelected);
    on<HrReportsSelectionCleared>(_onSelectionCleared);
  }

  final DashboardRepository _repository;

  /// Loads the selectable companies without auto-selecting one.
  ///
  /// The selector opens on the neutral "Ninguno" state ([selectedCompany]
  /// `null`), so the metrics canvas stays collapsed until a concrete company is
  /// picked.
  Future<void> _onStarted(
    HrReportsStarted event,
    Emitter<HrReportsState> emit,
  ) async {
    emit(state.copyWith(
      status: HrReportsStatus.loadingCompanies,
      errorMessage: null,
    ));
    try {
      final companies = await _repository.loadCompanies();
      emit(state.copyWith(
        status: HrReportsStatus.ready,
        companies: companies,
        selectedCompany: null,
        diagnosis: null,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: HrReportsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Selects a [Company] and loads its aggregated HR metrics.
  Future<void> _onCompanySelected(
    HrReportsCompanySelected event,
    Emitter<HrReportsState> emit,
  ) async {
    emit(state.copyWith(
      status: HrReportsStatus.loadingMetrics,
      selectedCompany: event.company,
      errorMessage: null,
    ));
    await _loadMetricsFor(event.company, emit);
  }

  /// Collapses the metrics canvas back to the neutral "Ninguno" state.
  void _onSelectionCleared(
    HrReportsSelectionCleared event,
    Emitter<HrReportsState> emit,
  ) {
    emit(state.copyWith(
      status: HrReportsStatus.ready,
      selectedCompany: null,
      diagnosis: null,
      errorMessage: null,
    ));
  }

  /// Shared loader: fetches the full [ClimateDiagnosis] for [company] via the
  /// RRHH climate-diagnosis endpoint and reduces the outcome into state.
  Future<void> _loadMetricsFor(
    Company company,
    Emitter<HrReportsState> emit,
  ) async {
    try {
      final ClimateDiagnosis diagnosis = await _repository.diagnoseClimate(
        companyId: int.parse(company.id.value),
      );
      emit(state.copyWith(
        status: HrReportsStatus.ready,
        diagnosis: diagnosis,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: HrReportsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
