import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/forum_message.dart';

part 'message_response.g.dart';

/// Inbound network contract for a `MessageResponse` nested inside a thread.
///
/// Only the fields the read-only RRHH view consumes are declared; unknown keys
/// (e.g. `attachments`) are ignored by the generated schema. Marked inbound-only
/// (`createToJson: false`).
@JsonSerializable(createToJson: false)
class MessageResponse {
  /// Creates a [MessageResponse] from its explicit wire fields.
  const MessageResponse({
    required this.messageId,
    required this.userAccountId,
    required this.contentMessage,
  });

  /// Server-driven unique identifier of the message.
  @JsonKey(name: 'message_id')
  final int messageId;

  /// Anonymous account identifier of the sender.
  @JsonKey(name: 'user_account_id')
  final int userAccountId;

  /// Body text of the message.
  @JsonKey(name: 'content_message')
  final String contentMessage;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [ForumMessage].
  ForumMessage toDomain() {
    return ForumMessage(
      id: Id(messageId.toString()),
      userAccountId: userAccountId,
      content: contentMessage,
    );
  }
}
