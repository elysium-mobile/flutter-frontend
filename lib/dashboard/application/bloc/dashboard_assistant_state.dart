part of 'dashboard_assistant_bloc.dart';

/// Lifecycle status of the HR AI Climate Assistant flow, decoupled from any UI
/// representation.
enum DashboardAssistantStatus {
  /// Nothing has been requested yet.
  initial,

  /// The selectable companies are being fetched.
  loadingCompanies,

  /// Companies are available; awaiting a diagnosis request.
  ready,

  /// A climate diagnosis is in flight.
  diagnosing,

  /// A diagnosis resolved successfully; inspect [DashboardAssistantState.diagnosis].
  success,

  /// A load or diagnosis failed; inspect [DashboardAssistantState.errorMessage].
  failure,
}

/// Immutable state of the HR AI Climate Assistant managed by
/// [DashboardAssistantBloc].
final class DashboardAssistantState extends Equatable {
  /// Creates a [DashboardAssistantState].
  const DashboardAssistantState({
    this.status = DashboardAssistantStatus.initial,
    this.companies = const <Company>[],
    this.selectedCompany,
    this.diagnosis,
    this.errorMessage,
  });

  /// Current lifecycle status of the flow.
  final DashboardAssistantStatus status;

  /// Companies populating the selector.
  final List<Company> companies;

  /// Currently selected company, or `null` before any selection.
  final Company? selectedCompany;

  /// The most recent diagnosis result, or `null` when none is available.
  final ClimateDiagnosis? diagnosis;

  /// Raw diagnostic error message when [status] is
  /// [DashboardAssistantStatus.failure].
  final String? errorMessage;

  /// Whether a diagnosis request is currently in flight.
  bool get isDiagnosing => status == DashboardAssistantStatus.diagnosing;

  /// Whether a diagnosis can be requested (a company is selected and no request
  /// is already running).
  bool get canDiagnose => selectedCompany != null && !isDiagnosing;

  /// Returns a copy overriding the provided fields. [selectedCompany],
  /// [diagnosis] and [errorMessage] use a sentinel so they can be explicitly
  /// cleared to `null`.
  DashboardAssistantState copyWith({
    DashboardAssistantStatus? status,
    List<Company>? companies,
    Object? selectedCompany = _sentinel,
    Object? diagnosis = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return DashboardAssistantState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      selectedCompany: identical(selectedCompany, _sentinel)
          ? this.selectedCompany
          : selectedCompany as Company?,
      diagnosis: identical(diagnosis, _sentinel)
          ? this.diagnosis
          : diagnosis as ClimateDiagnosis?,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        companies,
        selectedCompany,
        diagnosis,
        errorMessage,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
