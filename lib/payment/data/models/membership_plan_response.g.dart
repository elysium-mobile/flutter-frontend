// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_plan_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipPlanResponse _$MembershipPlanResponseFromJson(
  Map<String, dynamic> json,
) => MembershipPlanResponse(
  planId: (json['plan_id'] as num).toInt(),
  planName: json['plan_name'] as String,
  price: (json['price'] as num).toInt(),
  membershipId: (json['membership_id'] as num).toInt(),
);
