// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadResponse _$ThreadResponseFromJson(Map<String, dynamic> json) =>
    ThreadResponse(
      threadId: (json['thread_id'] as num).toInt(),
      title: json['title'] as String,
      lastMessage: json['last_message'] as String?,
      messageCount: (json['message_count'] as num).toInt(),
      messageResponses:
          (json['message_responses'] as List<dynamic>?)
              ?.map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
