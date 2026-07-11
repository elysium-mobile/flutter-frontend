// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForumResponse _$ForumResponseFromJson(Map<String, dynamic> json) =>
    ForumResponse(
      forumId: (json['forum_id'] as num).toInt(),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
