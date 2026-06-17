/// Centralized management utility for fetching compile-time configuration
/// values.
///
/// This class utilizes [String.fromEnvironment] to safely map keys passed during
/// the compilation build pipeline (via `--dart-define` or
/// `--dart-define-from-file`) into typed runtime fields accessible by the
/// infrastructure and data adapter layers.
///
/// Every value resolves to a semantic fallback or an empty string when its key
/// is omitted, so compilation never fails when a particular pipeline step does
/// not provide a given variable. The class is non-instantiable; it exposes
/// configuration exclusively as `const` static members.
abstract final class EnvironmentConfig {
  /// When true, structural network endpoints and security adapters load
  /// pre-baked mock models instead of live infrastructure.
  ///
  /// Toggled via `--dart-define=IS_MOCK_MODE=true`, selecting the
  /// Local/Develop flavor at the service-locator composition root.
  static const bool isMockMode = bool.fromEnvironment(
    'IS_MOCK_MODE',
    defaultValue: false,
  );

  /// The base URL string targeting the authoritative enterprise backend
  /// services.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.softwork.com',
  );

  /// Root path prefix prepended to every relative API endpoint.
  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '/v1',
  );

  /// Network request timeout, in seconds, applied to backend exchanges.
  static const int apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 20,
  );

  /// Whether the centralized network client emits diagnostic request/response
  /// logging. Enabled via `--dart-define=API_LOGGING=true`.
  static const bool apiLoggingEnabled = bool.fromEnvironment(
    'API_LOGGING',
    defaultValue: false,
  );

  /// Google OAuth Web Client Server Identifier required for credential bridging.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  /// Public cryptographic API identifier key for target Firebase projects.
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
  );

  /// Unique app registration identifier within the targeted Firebase console.
  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
  );

  /// Firebase Cloud Messaging routing identifier for delivery tracking.
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );

  /// Explicit Google Project name binding matching the deployment target
  /// console.
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  /// Shared storage repository bucket naming used for static asset file
  /// tracking.
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );

  /// Whether a complete set of Firebase overrides was supplied at build time.
  ///
  /// When `false`, the application falls back to the platform's native Firebase
  /// configuration (`google-services.json` / `GoogleService-Info.plist`) instead
  /// of constructing explicit options from these (empty) values.
  static bool get hasFirebaseConfiguration =>
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseMessagingSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;
}
