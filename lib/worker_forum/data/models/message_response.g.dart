// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageResponse _$MessageResponseFromJson(Map<String, dynamic> json) =>
    MessageResponse(
      messageId: (json['message_id'] as num).toInt(),
      userAccountId: (json['user_account_id'] as num).toInt(),
      contentMessage: json['content_message'] as String,
    );
