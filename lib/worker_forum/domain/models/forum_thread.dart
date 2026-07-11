import '../../../shared/domain/models/id.dart';
import 'forum_message.dart';

/// Immutable domain entity representing a forum thread and its message stream.
///
/// Pure by construction, with hand-written value equality. The [messages] are
/// carried inline because the company forum endpoint returns them nested inside
/// each thread, so the read-only conversation view needs no extra fetch.
class ForumThread {
  /// Creates an immutable [ForumThread].
  const ForumThread({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.messageCount,
    required this.messages,
  });

  /// Stable identifier of the thread.
  final Id id;

  /// Display title of the thread.
  final String title;

  /// Raw ISO 8601 timestamp string of the thread's last activity
  /// (`last_message`), rendered verbatim on the cards.
  final String timestamp;

  /// Total number of messages in the thread (`message_count`).
  final int messageCount;

  /// Chronological message stream nested with the thread.
  final List<ForumMessage> messages;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForumThread &&
        other.id == id &&
        other.title == title &&
        other.timestamp == timestamp &&
        other.messageCount == messageCount &&
        _sameMessages(other.messages, messages);
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        timestamp,
        messageCount,
        Object.hashAll(messages),
      );

  /// Order-sensitive structural comparison of two message streams.
  static bool _sameMessages(List<ForumMessage> a, List<ForumMessage> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
