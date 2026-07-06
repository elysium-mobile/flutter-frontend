import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/membership_plan.dart';
import '../../domain/repositories/payment_repository.dart';

part 'plan_selection_event.dart';
part 'plan_selection_state.dart';

/// Business Logic Component orchestrating the plan-selection ("Membresías")
/// screen and the purchase lifecycle it triggers.
///
/// Loads the offered plans and, on selection, drives the purchase through the
/// [PaymentRepository]. No navigation happens here: the view reacts to
/// [PlanSelectionStatus] transitions (notably [PlanSelectionStatus.purchased]).
class PlanSelectionBloc extends Bloc<PlanSelectionEvent, PlanSelectionState> {
  /// Creates a [PlanSelectionBloc] bound to the [PaymentRepository] port.
  PlanSelectionBloc({required PaymentRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const PlanSelectionState()) {
    on<PlanSelectionStarted>(_onStarted);
    on<PlanSelectionPurchaseRequested>(_onPurchaseRequested);
  }

  final PaymentRepository _repository;

  /// Loads the offered plans.
  Future<void> _onStarted(
    PlanSelectionStarted event,
    Emitter<PlanSelectionState> emit,
  ) async {
    emit(state.copyWith(status: PlanSelectionStatus.loading, errorMessage: null));
    try {
      final plans = await _repository.loadPlans();
      emit(state.copyWith(status: PlanSelectionStatus.ready, plans: plans));
    } catch (error) {
      emit(state.copyWith(
        status: PlanSelectionStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Purchases the selected plan for the authenticated account.
  Future<void> _onPurchaseRequested(
    PlanSelectionPurchaseRequested event,
    Emitter<PlanSelectionState> emit,
  ) async {
    emit(state.copyWith(
      status: PlanSelectionStatus.purchasing,
      selectedPlan: event.plan,
      errorMessage: null,
    ));
    try {
      final membership = await _repository.purchasePlan(
        plan: event.plan,
        userAccountId: event.userAccountId,
      );
      emit(state.copyWith(
        status: PlanSelectionStatus.purchased,
        acquiredMembership: membership,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PlanSelectionStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
