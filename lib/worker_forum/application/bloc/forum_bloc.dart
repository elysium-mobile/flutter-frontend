import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/models/forum_thread.dart';
import '../../domain/repositories/forum_repository.dart';

part 'forum_event.dart';
part 'forum_state.dart';

/// Business Logic Component orchestrating the read-only RRHH Worker Forum.
///
/// It loads the company-scoped thread list on start and reduces it into a
/// renderable [ForumState]. No mutation intents exist — the RRHH user is a pure
/// observer, so there are no create/reply events. No navigation leaks in here.
class ForumBloc extends Bloc<ForumEvent, ForumState> {
  /// Creates a [ForumBloc] bound to the [ForumRepository] port.
  ForumBloc({required ForumRepository repository})
      : _repository = repository, // ignore: prefer_initializing_formals
        super(const ForumState()) {
    on<ForumStarted>(_onStarted);
  }

  final ForumRepository _repository;

  /// Loads the company's threads.
  Future<void> _onStarted(
    ForumStarted event,
    Emitter<ForumState> emit,
  ) async {
    emit(state.copyWith(status: ForumStatus.loading, errorMessage: null));
    try {
      final threads = await _repository.loadCompanyThreads();
      emit(state.copyWith(status: ForumStatus.ready, threads: threads));
    } catch (error) {
      emit(state.copyWith(
        status: ForumStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }
}
