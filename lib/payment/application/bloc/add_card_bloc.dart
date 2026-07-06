import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/payment_card.dart';
import '../../domain/repositories/payment_repository.dart';

part 'add_card_event.dart';
part 'add_card_state.dart';

/// Business Logic Component orchestrating the card-provisioning ("Agregar método
/// de pago") form.
///
/// Reduces the form fields, validates them, and — on submission — projects the
/// non-sensitive card fields into a [PaymentCard] persisted through the
/// [PaymentRepository]. The full card number and CVV are used only transiently
/// to derive the brand and last four digits; they are never stored.
class AddCardBloc extends Bloc<AddCardEvent, AddCardState> {
  /// Creates an [AddCardBloc] bound to the [PaymentRepository] port.
  AddCardBloc({required PaymentRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const AddCardState()) {
    on<AddCardHolderChanged>(_onHolderChanged);
    on<AddCardNumberChanged>(_onNumberChanged);
    on<AddCardExpiryChanged>(_onExpiryChanged);
    on<AddCardCvvChanged>(_onCvvChanged);
    on<AddCardSaveToggled>(_onSaveToggled);
    on<AddCardSubmitted>(_onSubmitted);
  }

  final PaymentRepository _repository;

  void _onHolderChanged(AddCardHolderChanged event, Emitter<AddCardState> emit) {
    emit(state.copyWith(
      cardHolder: event.value,
      status: AddCardStatus.editing,
      errorMessage: null,
    ));
  }

  void _onNumberChanged(AddCardNumberChanged event, Emitter<AddCardState> emit) {
    emit(state.copyWith(
      cardNumber: event.value,
      status: AddCardStatus.editing,
      errorMessage: null,
    ));
  }

  void _onExpiryChanged(AddCardExpiryChanged event, Emitter<AddCardState> emit) {
    emit(state.copyWith(
      expiry: event.value,
      status: AddCardStatus.editing,
      errorMessage: null,
    ));
  }

  void _onCvvChanged(AddCardCvvChanged event, Emitter<AddCardState> emit) {
    emit(state.copyWith(
      cvv: event.value,
      status: AddCardStatus.editing,
      errorMessage: null,
    ));
  }

  void _onSaveToggled(AddCardSaveToggled event, Emitter<AddCardState> emit) {
    emit(state.copyWith(saveCard: event.value));
  }

  Future<void> _onSubmitted(
    AddCardSubmitted event,
    Emitter<AddCardState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: AddCardStatus.submitting, errorMessage: null));
    try {
      final PaymentCard card = _buildCard(state);
      // Persist only when the user opted in via the "Save this card" toggle.
      final PaymentCard result =
          state.saveCard ? await _repository.saveCard(card) : card;
      emit(state.copyWith(status: AddCardStatus.success, savedCard: result));
    } catch (error) {
      emit(state.copyWith(
        status: AddCardStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  /// Projects the validated form fields into a non-sensitive [PaymentCard].
  static PaymentCard _buildCard(AddCardState state) {
    final String digits = state.digitsOnlyNumber;
    final String last4 = digits.substring(digits.length - 4);
    final List<String> expiryParts = state.expiryParts;
    return PaymentCard(
      id: const Id.empty(),
      cardHolder: state.cardHolder.trim(),
      last4: last4,
      expiryMonth: expiryParts.first,
      expiryYear: expiryParts.last,
      brand: _brandOf(digits),
    );
  }

  /// Best-effort card-brand detection from the leading digit(s).
  static String _brandOf(String digits) {
    if (digits.startsWith('4')) return 'VISA';
    if (digits.startsWith('5')) return 'MASTERCARD';
    if (digits.startsWith('34') || digits.startsWith('37')) return 'AMEX';
    return 'CARD';
  }
}
