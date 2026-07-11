import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/forum_thread.dart';
import 'message_response.dart';

part 'thread_response.g.dart';

/// Inbound network contract for a `ThreadResponse` nested inside a category.
///
/// Deserializes the thread fields the read-only view needs plus the nested
/// `message_responses`. A null/absent message list defaults to empty. Marked
/// inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class ThreadResponse {
  /// Creates a [ThreadResponse] from its explicit wire fields.
  const ThreadResponse({
    required this.threadId,
    required this.title,
    required this.lastMessage,
    required this.messageCount,
    required this.messageResponses,
  });

  /// Server-driven unique identifier of the thread.
  @JsonKey(name: 'thread_id')
  final int threadId;

  /// Display title of the thread.
  @JsonKey(name: 'title')
  final String title;

  /// Raw ISO 8601 timestamp string of the thread's last activity.
  @JsonKey(name: 'last_message')
  final String? lastMessage;

  /// Total number of messages in the thread.
  @JsonKey(name: 'message_count')
  final int messageCount;

  /// Nested message stream (`message_responses`); empty when absent.
  @JsonKey(name: 'message_responses', defaultValue: <MessageResponse>[])
  final List<MessageResponse> messageResponses;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory ThreadResponse.fromJson(Map<String, dynamic> json) =>
      _$ThreadResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [ForumThread].
  ForumThread toDomain() {
    return ForumThread(
      id: Id(threadId.toString()),
      title: title,
      timestamp: lastMessage ?? '',
      messageCount: messageCount,
      messages: messageResponses.map((MessageResponse m) => m.toDomain()).toList(),
    );
  }
}
