part of 'hr_reports_bloc.dart';

/// Base type for every intent the HR Analytics screen dispatches to
/// [HrReportsBloc].
sealed class HrReportsEvent extends Equatable {
  /// Const constructor for subclasses.
  const HrReportsEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The screen was opened; load the selectable companies.
final class HrReportsStarted extends HrReportsEvent {
  /// Creates an [HrReportsStarted].
  const HrReportsStarted();
}

/// A company was chosen in the selector; load its aggregated HR metrics.
final class HrReportsCompanySelected extends HrReportsEvent {
  /// Creates an [HrReportsCompanySelected].
  const HrReportsCompanySelected(this.company);

  /// The newly selected company.
  final Company company;

  @override
  List<Object?> get props => <Object?>[company];
}

/// The neutral "Ninguno" (none) option was chosen; collapse the metrics canvas.
final class HrReportsSelectionCleared extends HrReportsEvent {
  /// Creates an [HrReportsSelectionCleared].
  const HrReportsSelectionCleared();
}
