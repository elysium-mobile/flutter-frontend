import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing an authenticated SoftWork employee.
///
/// One of only two IAM domain entities. It is completely pure: no annotations,
/// serialization tokens or infrastructure dependencies cross into it. Value
/// equality is implemented by hand to stay framework-agnostic.
class User {
  /// Creates an immutable [User].
  const User({
    required this.id,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  /// Stable unique identifier assigned by the identity provider/backend.
  final Id id;

  /// Public display name chosen by the employee.
  final String username;

  /// Institutional (corporate) email address bound to the account.
  final String email;

  /// Optional remote avatar URL (e.g. provided by Google Sign-In).
  final String? photoUrl;

  /// Returns a copy of this [User] overriding only the provided fields.
  User copyWith({
    Id? id,
    String? username,
    String? email,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.photoUrl == photoUrl;
  }

  @override
  int get hashCode => Object.hash(id, username, email, photoUrl);

  @override
  String toString() => 'User(id: $id, username: $username, email: $email)';
}
