/// Canonical, type-safe catalogue of the IAM feature's navigation routes.
///
/// Centralizing the path/name literals keeps `go_router` configuration,
/// redirects and call sites consistent and refactor-safe.
abstract final class IamRoutes {
  /// Path of the login screen (feature entry point).
  static const String loginPath = '/iam/login';

  /// Symbolic name of the login route.
  static const String loginName = 'iam-login';

  /// Path of the email registration form.
  static const String registerPath = '/iam/register';

  /// Symbolic name of the registration route.
  static const String registerName = 'iam-register';

  /// Path of the "Session Started" success interstitial.
  static const String sessionStartedPath = '/iam/session-started';

  /// Symbolic name of the "Session Started" route.
  static const String sessionStartedName = 'iam-session-started';

  /// Path of the "User Registered" success interstitial.
  static const String userRegisteredPath = '/iam/user-registered';

  /// Symbolic name of the "User Registered" route.
  static const String userRegisteredName = 'iam-user-registered';

  /// Path of the profile view (a tab inside the authenticated shell).
  static const String profilePath = '/profile';

  /// Symbolic name of the profile route.
  static const String profileName = 'iam-profile';

  /// Path of the profile configuration (edit) form.
  static const String profileEditPath = '/profile/edit';

  /// Symbolic name of the profile configuration route.
  static const String profileEditName = 'iam-profile-edit';
}
