part of 'dashboard_assistant_bloc.dart';

/// Base type for every intent understood by [DashboardAssistantBloc].
sealed class DashboardAssistantEvent extends Equatable {
  /// Const base constructor for subclasses.
  const DashboardAssistantEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Bootstraps the screen by loading the selectable companies.
final class DashboardAssistantStarted extends DashboardAssistantEvent {
  /// Creates a [DashboardAssistantStarted].
  const DashboardAssistantStarted();
}

/// The HR specialist chose the [company] to analyze.
final class DashboardAssistantCompanySelected extends DashboardAssistantEvent {
  /// Creates a [DashboardAssistantCompanySelected] for [company].
  const DashboardAssistantCompanySelected(this.company);

  /// The company the diagnosis will target.
  final Company company;

  @override
  List<Object?> get props => <Object?>[company];
}

/// The HR specialist requested a climate diagnosis with an optional [question].
final class ClimateDiagnosisRequested extends DashboardAssistantEvent {
  /// Creates a [ClimateDiagnosisRequested] carrying the optional [question].
  const ClimateDiagnosisRequested({this.question});

  /// Optional free-text steering question; null/blank runs a general diagnosis.
  final String? question;

  @override
  List<Object?> get props => <Object?>[question];
}
