// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      orderId: (json['order_id'] as num).toInt(),
      userAccountId: (json['user_account_id'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      membershipId: (json['membership_id'] as num).toInt(),
    );
