// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      categoryId: (json['category_id'] as num).toInt(),
      threads:
          (json['threads'] as List<dynamic>?)
              ?.map((e) => ThreadResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
