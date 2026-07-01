import 'package:drift/drift.dart' show Value;

import '../../../shared/data/local/app_database.dart';
import '../../../shared/domain/models/id.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/user.dart';

/// Structural mapping from a persisted [CachedSession] database row to the pure
/// domain [AuthSession] model.
///
/// Keeps the relational boundary out of the domain: the generated Drift data
/// class is translated here rather than inside the entity itself. The cached row
/// only retains the credential material, so the rehydrated [User] carries the
/// stored identifier with empty profile fields until a fresh profile is fetched.
extension CachedSessionRowMapper on CachedSession {
  /// Rehydrates a domain [AuthSession] from this cached database row.
  AuthSession toDomain() {
    return AuthSession(
      user: User(
        id: Id(userId),
        username: '',
        email: '',
      ),
      accessToken: accessToken,
    );
  }
}

/// Structural mapping from a domain [AuthSession] to a database-compatible
/// [CachedSessionsCompanion] used for typed insertions/updates.
///
/// Companion contracts let Drift receive only the explicitly-set columns, so the
/// auto-incremented primary key is intentionally left absent.
extension AuthSessionCompanionMapper on AuthSession {
  /// Converts this domain session into a [CachedSessionsCompanion] payload.
  CachedSessionsCompanion toCompanion() {
    return CachedSessionsCompanion(
      accessToken: Value(accessToken),
      userId: Value(user.id.value),
    );
  }
}
