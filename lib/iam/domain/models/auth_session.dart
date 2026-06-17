import 'user.dart';

/// Immutable core domain entity representing an established authentication
/// session.
///
/// The second and final IAM domain entity. It bundles the authenticated [User]
/// with the backend-issued credentials authorizing subsequent API calls, and
/// remains a pure domain type with no external dependencies.
class AuthSession {
  /// Creates an immutable [AuthSession].
  const AuthSession({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  /// The authenticated employee owning this session.
  final User user;

  /// Bearer token authorizing access to protected backend resources.
  final String accessToken;

  /// Optional token used to silently renew an expired [accessToken].
  final String? refreshToken;

  /// Optional absolute expiry timestamp of the [accessToken].
  final DateTime? expiresAt;

  /// Whether the [accessToken] is known to be expired.
  ///
  /// Returns `false` when [expiresAt] is unknown, deferring validity to the
  /// backend as the single source of truth.
  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  /// Returns a copy of this [AuthSession] overriding only the provided fields.
  AuthSession copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthSession &&
        other.user == user &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode => Object.hash(user, accessToken, refreshToken, expiresAt);
}
