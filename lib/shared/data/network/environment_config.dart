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
  /// The base URL string targeting the authoritative SoftWork/ELYSIUM backend
  /// services.
  ///
  /// Injected via the compile-time configuration file
  /// (`--dart-define-from-file=lib/config.json`, key `BACKEND_BASE_URL`), which
  /// overrides the default below. A non-secret production default is baked in so
  /// the app still reaches the backend when a build forgets the config flag —
  /// without it, an empty host makes every request (starting with login) fail.
  /// A trailing slash is tolerated — request composition normalizes it (see
  /// [ApiClient]).
  static const String apiBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'https://api.elysium-mobile.online',
  );

  /// Root path prefix prepended to every relative API endpoint.
  ///
  /// The ELYSIUM backend exposes every controller under `/api/v1`.
  static const String apiPrefix = String.fromEnvironment(
    'API_PREFIX',
    defaultValue: '/api/v1',
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

  /// Google OAuth 2.0 Client Identifier — the expected audience of Google ID
  /// tokens and the `serverClientId` used by the Google Sign-In credential
  /// bridge.
  ///
  /// Injected via the compile-time configuration file (key `GOOGLE_OAUTH_CLIENT`,
  /// consumed through `--dart-define-from-file=lib/config.json`). No inline
  /// default: an omitted key resolves to the empty string.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_OAUTH_CLIENT',
  );

  /// Google Gemini (GenAI) secret API key used for direct AI client handshakes.
  ///
  /// Injected via the compile-time configuration file (key `API_KEY_GEMINI`,
  /// consumed through `--dart-define-from-file=lib/config.json`). Reserved for
  /// the AI-assistant integration; not yet consumed by a client-side Gemini
  /// adapter (the dashboard-assistant endpoint remains a backend surface).
  static const String geminiApiKey = String.fromEnvironment('API_KEY_GEMINI');

  /// Stripe publishable key bound to the live payment gateway.
  ///
  /// Injected via the compile-time configuration file (key
  /// `PUBLISHABLE_KEY_STRIPE`, consumed through
  /// `--dart-define-from-file=lib/config.json`). Reserved for a client-side
  /// Stripe SDK confirmation flow; the current checkout path confirms with a
  /// server-issued PaymentIntent `client_secret`, so this key is not yet read at
  /// runtime.
  static const String stripePublishableKey =
      String.fromEnvironment('PUBLISHABLE_KEY_STRIPE');

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
