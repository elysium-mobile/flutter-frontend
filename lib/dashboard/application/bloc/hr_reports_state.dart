part of 'hr_reports_bloc.dart';

/// Lifecycle status of the HR Analytics flow, decoupled from any UI
/// representation.
enum HrReportsStatus {
  /// Nothing has been requested yet.
  initial,

  /// The selectable companies are being fetched.
  loadingCompanies,

  /// Aggregated metrics for the selected company are being fetched.
  loadingMetrics,

  /// Companies (and, when one is selected, its metrics) are available.
  ready,

  /// A load failed; inspect [HrReportsState.errorMessage].
  failure,
}

/// Immutable state of the HR Analytics screen managed by [HrReportsBloc].
final class HrReportsState extends Equatable {
  /// Creates an [HrReportsState].
  const HrReportsState({
    this.status = HrReportsStatus.initial,
    this.companies = const <Company>[],
    this.selectedCompany,
    this.diagnosis,
    this.errorMessage,
  });

  /// Current lifecycle status of the flow.
  final HrReportsStatus status;

  /// Companies populating the selector.
  final List<Company> companies;

  /// Currently selected company, or `null` before any selection.
  final Company? selectedCompany;

  /// Full climate diagnosis for [selectedCompany] (status + analysis +
  /// metrics), or `null` until one is loaded. Retained in full so the
  /// "Generate report" detail can render without another network call.
  final ClimateDiagnosis? diagnosis;

  /// Raw diagnostic error message when [status] is [HrReportsStatus.failure].
  final String? errorMessage;

  /// Aggregated metrics projected from [diagnosis]; a zeroed snapshot when
  /// none is loaded. Drives the summary tiles.
  ClimateMetrics get metrics =>
      diagnosis?.metrics ?? const ClimateMetrics.empty();

  /// Whether the metrics panel should render its loading affordance.
  bool get isLoadingMetrics => status == HrReportsStatus.loadingMetrics;

  /// Returns a copy overriding the provided fields. [selectedCompany],
  /// [diagnosis] and [errorMessage] use a sentinel so they can be explicitly
  /// cleared to `null`.
  HrReportsState copyWith({
    HrReportsStatus? status,
    List<Company>? companies,
    Object? selectedCompany = _sentinel,
    Object? diagnosis = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return HrReportsState(
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
