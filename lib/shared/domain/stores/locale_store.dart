import '../models/app_language.dart';

/// Port abstracting persistence of the user's selected interface language.
///
/// Declared in `domain/` so the application layer (`LocaleBloc`) depends on this
/// contract rather than on the concrete `shared_preferences` adapter, preserving
/// the inward dependency direction. The implementation lives in `data/`.
abstract interface class LocaleStore {
  /// Reads the persisted language, or `null` when the user has never chosen one.
  Future<AppLanguage?> readLanguage();

  /// Persists [language] as the active interface language.
  Future<void> writeLanguage(AppLanguage language);
}
