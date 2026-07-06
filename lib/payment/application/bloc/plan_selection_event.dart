part of 'plan_selection_bloc.dart';

/// Base type for every intent the plan-selection screen dispatches.
sealed class PlanSelectionEvent extends Equatable {
  /// Const constructor for subclasses.
  const PlanSelectionEvent();

  @override
  List<Object?> get props => const <Object?>[];
}

/// The screen was opened; load the offered plans.
final class PlanSelectionStarted extends PlanSelectionEvent {
  /// Creates a [PlanSelectionStarted].
  const PlanSelectionStarted();
}

/// A plan's "Seleccionar plan" button was pressed; purchase it.
final class PlanSelectionPurchaseRequested extends PlanSelectionEvent {
  /// Creates a [PlanSelectionPurchaseRequested].
  const PlanSelectionPurchaseRequested({
    required this.plan,
    required this.userAccountId,
  });

  /// The plan being purchased.
  final MembershipPlan plan;

  /// Identifier of the purchasing user account.
  final Id userAccountId;

  @override
  List<Object?> get props => <Object?>[plan, userAccountId];
}
