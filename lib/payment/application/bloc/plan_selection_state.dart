part of 'plan_selection_bloc.dart';

/// Lifecycle status of the plan-selection and purchase flow.
enum PlanSelectionStatus {
  /// Nothing has been requested yet.
  initial,

  /// The plans are being fetched.
  loading,

  /// The plans are available for selection.
  ready,

  /// A purchase is in flight.
  purchasing,

  /// The purchase succeeded and the membership was synchronized.
  purchased,

  /// A load or purchase failed; inspect [PlanSelectionState.errorMessage].
  failure,
}

/// Immutable state of the plan-selection screen managed by [PlanSelectionBloc].
final class PlanSelectionState extends Equatable {
  /// Creates a [PlanSelectionState].
  const PlanSelectionState({
    this.status = PlanSelectionStatus.initial,
    this.plans = const <MembershipPlan>[],
    this.selectedPlan,
    this.acquiredMembership,
    this.errorMessage,
  });

  /// Current lifecycle status of the flow.
  final PlanSelectionStatus status;

  /// Plans offered for selection.
  final List<MembershipPlan> plans;

  /// Plan currently being purchased, or `null`.
  final MembershipPlan? selectedPlan;

  /// Membership acquired on a successful purchase, or `null`.
  final Membership? acquiredMembership;

  /// Raw diagnostic error message when [status] is [PlanSelectionStatus.failure].
  final String? errorMessage;

  /// Whether a purchase is currently in flight.
  bool get isPurchasing => status == PlanSelectionStatus.purchasing;

  /// Returns a copy overriding the provided fields. [selectedPlan],
  /// [acquiredMembership] and [errorMessage] use a sentinel so they can be
  /// explicitly cleared to `null`.
  PlanSelectionState copyWith({
    PlanSelectionStatus? status,
    List<MembershipPlan>? plans,
    Object? selectedPlan = _sentinel,
    Object? acquiredMembership = _sentinel,
    Object? errorMessage = _sentinel,
  }) {
    return PlanSelectionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      selectedPlan: identical(selectedPlan, _sentinel)
          ? this.selectedPlan
          : selectedPlan as MembershipPlan?,
      acquiredMembership: identical(acquiredMembership, _sentinel)
          ? this.acquiredMembership
          : acquiredMembership as Membership?,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        plans,
        selectedPlan,
        acquiredMembership,
        errorMessage,
      ];
}

/// Private sentinel distinguishing "field omitted" from "field set to null".
const Object _sentinel = Object();
