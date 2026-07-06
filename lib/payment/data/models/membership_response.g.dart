// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipResponse _$MembershipResponseFromJson(Map<String, dynamic> json) =>
    MembershipResponse(
      membershipId: (json['membership_id'] as num).toInt(),
      membershipStart: json['membership_start'] as String,
      membershipOver: json['membership_over'] as String,
      membershipStatus: json['membership_status'] as String,
    );
