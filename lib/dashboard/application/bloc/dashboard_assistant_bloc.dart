import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/company.dart';
import '../../domain/repositories/dashboard_repository.dart';

part 'dashboard_assistant_event.dart';
part 'dashboard_assistant_state.dart';

/// Business Logic Component orchestrating the HR AI Climate Assistant screen.
///
/// It owns two coupled concerns behind a single state machine: loading the
/// companies visible to the HR specialist (populating the company selector) and
/// requesting an AI climate diagnosis for the selected company. UI intents are
/// the only inputs; no navigation or widget concern leaks in here — the
/// presentation layer reacts to [DashboardAssistantStatus].
class DashboardAssistantBloc
    extends Bloc<DashboardAssistantEvent, DashboardAssistantState> {
  /// Creates a [DashboardAssistantBloc] bound to the [DashboardRepository] port.
  DashboardAssistantBloc({required DashboardRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const DashboardAssistantState()) {
    on<DashboardAssistantStarted>(_onStarted);
    on<DashboardAssistantCompanySelected>(_onCompanySelected);
    on<ClimateDiagnosisRequested>(_onDiagnosisRequested);
  }

  final DashboardRepository _repository;

  /// Loads the selectable companies without auto-selecting one.
  Future<void> _onStarted(
    DashboardAssistantStarted event,
    Emitter<DashboardAssistantState> emit,
  ) async {
    emit(state.copyWith(
      status: DashboardAssistantStatus.loadingCompanies,
      errorMessage: null,
    ));
    try {
      final companies = await _repository.loadCompanies();
      emit(state.copyWith(
        status: DashboardAssistantStatus.ready,
        companies: companies,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DashboardAssistantStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Records the company the diagnosis will target, clearing any prior result.
  void _onCompanySelected(
    DashboardAssistantCompanySelected event,
    Emitter<DashboardAssistantState> emit,
  ) {
    emit(state.copyWith(
      status: DashboardAssistantStatus.ready,
      selectedCompany: event.company,
      diagnosis: null,
      errorMessage: null,
    ));
  }

  /// Requests an AI climate diagnosis for the currently selected company.
  ///
  /// A no-op when no company is selected. On success the resolved
  /// [ClimateDiagnosis] is retained in state alongside the selection.
  Future<void> _onDiagnosisRequested(
    ClimateDiagnosisRequested event,
    Emitter<DashboardAssistantState> emit,
  ) async {
    final Company? company = state.selectedCompany;
    if (company == null) return;

    emit(state.copyWith(
      status: DashboardAssistantStatus.diagnosing,
      diagnosis: null,
      errorMessage: null,
    ));
    try {
      final diagnosis = await _repository.diagnoseClimate(
        companyId: int.parse(company.id.value),
        question: event.question,
      );
      emit(state.copyWith(
        status: DashboardAssistantStatus.success,
        diagnosis: diagnosis,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: DashboardAssistantStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
