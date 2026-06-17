import 'package:shared_preferences/shared_preferences.dart';

/// Single global key-value storage adapter wrapping `shared_preferences`.
///
/// Centralizes session retention, global flags and user preferences behind one
/// typed API so feature code never touches `shared_preferences` directly. Keys
/// are namespaced constants to avoid collisions across bounded contexts.
class SharedPreferencesAdapter {
  /// Creates an adapter around an already-resolved [SharedPreferences].
  SharedPreferencesAdapter(this._prefs);

  /// Asynchronously resolves the platform store and wraps it.
  ///
  /// Call once during bootstrap, before registering dependencies that read from
  /// the cache.
  static Future<SharedPreferencesAdapter> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesAdapter(prefs);
  }

  final SharedPreferences _prefs;

  /// Storage key holding the persisted session access token.
  static const String sessionTokenKey = 'session.access_token';

  /// Storage key holding the "onboarding completed" global flag.
  static const String onboardingCompletedKey = 'global.onboarding_completed';

  /// Reads the string stored under [key], or `null` when absent.
  String? getString(String key) => _prefs.getString(key);

  /// Writes [value] under [key].
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Reads the boolean stored under [key], defaulting to [defaultValue].
  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  /// Writes the boolean [value] under [key].
  Future<void> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Removes any value stored under [key].
  Future<void> remove(String key) => _prefs.remove(key);

  /// Clears every stored value.
  Future<void> clear() => _prefs.clear();

  // --- Session convenience API ------------------------------------------------

  /// The persisted session access token, or `null` when unauthenticated.
  String? get sessionToken => getString(sessionTokenKey);

  /// Persists the session [token] for later silent re-authentication.
  Future<void> saveSessionToken(String token) =>
      setString(sessionTokenKey, token);

  /// Drops any persisted session token.
  Future<void> clearSession() => remove(sessionTokenKey);
}
