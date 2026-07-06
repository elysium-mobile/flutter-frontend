import '../../domain/models/app_language.dart';
import '../../domain/stores/locale_store.dart';
import 'shared_preferences_adapter.dart';

/// [LocaleStore] adapter persisting the language preference in the global
/// key-value cache ([SharedPreferencesAdapter]).
///
/// Maps the pure-domain [AppLanguage] to/from its ISO-639 [AppLanguage.code]
/// under a single namespaced key, so the domain never learns how the preference
/// is stored.
class PreferencesLocaleStore implements LocaleStore {
  /// Creates a [PreferencesLocaleStore] over the resolved [preferences] cache.
  PreferencesLocaleStore(this._preferences);

  final SharedPreferencesAdapter _preferences;

  /// Namespaced key holding the persisted language code.
  static const String languageCodeKey = 'global.language_code';

  @override
  Future<AppLanguage?> readLanguage() async {
    return AppLanguage.fromCode(_preferences.getString(languageCodeKey));
  }

  @override
  Future<void> writeLanguage(AppLanguage language) {
    return _preferences.setString(languageCodeKey, language.code);
  }
}
