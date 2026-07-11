import '../models/forum_thread.dart';

/// Port (hexagonal) describing the read-only forum data-access capability
/// required by the RRHH application layer.
///
/// Expressed purely in terms of domain types: the application layer depends on
/// this contract, never on the concrete network adapter. The implementation is
/// responsible for scoping the data to the authenticated HR manager's company
/// (multi-tenant filtering) and flattening the forum tree into threads.
///
/// Operations communicate failure by throwing an [Exception]; the BLoC catches
/// it once and reduces it into a renderable error state.
abstract interface class ForumRepository {
  /// Loads every thread visible under the authenticated HR manager's company,
  /// aggregated across that company's forums and categories.
  Future<List<ForumThread>> loadCompanyThreads();
}
