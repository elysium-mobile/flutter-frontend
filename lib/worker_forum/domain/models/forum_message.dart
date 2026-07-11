import '../../../shared/domain/models/id.dart';

/// Immutable domain entity representing a single anonymous forum message.
///
/// Pure by construction (no serialization or infrastructure imports), with
/// hand-written value equality. The sender is intentionally reduced to an
/// anonymous [userAccountId]; the RRHH observer never sees a real identity.
class ForumMessage {
  /// Creates an immutable [ForumMessage].
  const ForumMessage({
    required this.id,
    required this.userAccountId,
    required this.content,
  });

  /// Stable identifier of the message.
  final Id id;

  /// Anonymous account identifier of the sender (rendered as "User #N").
  final int userAccountId;

  /// Body text of the message (`content_message`).
  final String content;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForumMessage &&
        other.id == id &&
        other.userAccountId == userAccountId &&
        other.content == content;
  }

  @override
  int get hashCode => Object.hash(id, userAccountId, content);
}
