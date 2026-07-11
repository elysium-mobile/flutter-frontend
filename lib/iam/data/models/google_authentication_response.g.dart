// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_authentication_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleAuthenticationResponse _$GoogleAuthenticationResponseFromJson(
  Map<String, dynamic> json,
) => GoogleAuthenticationResponse(
  registered: json['registered'] as bool,
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  token: json['token'] as String?,
);
