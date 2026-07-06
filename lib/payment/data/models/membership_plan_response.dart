import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/membership_plan.dart';

part 'membership_plan_response.g.dart';

/// Inbound network contract describing the membership-plan payload returned by
/// the ELYSIUM `/api/v1/membership-plans` resource.
///
/// A raw serialization boundary mirroring the snake_case wire schema.
/// Deserialization is delegated to the generated `@JsonSerializable` schema;
/// projection into the pure domain layer is exposed through [toDomain]. Marked
/// inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class MembershipPlanResponse {
  /// Creates a [MembershipPlanResponse] from its explicit wire fields.
  const MembershipPlanResponse({
    required this.planId,
    required this.planName,
    required this.price,
    required this.membershipId,
  });

  /// Server-driven unique identifier of the plan.
  @JsonKey(name: 'plan_id')
  final int planId;

  /// Commercial name of the plan.
  @JsonKey(name: 'plan_name')
  final String planName;

  /// Monthly price of the plan.
  @JsonKey(name: 'price')
  final int price;

  /// Identifier of the membership period provisioned by the plan.
  ///
  /// Required downstream to build the purchase order; the backend includes it in
  /// the plan payload alongside the headline `plan_id`/`plan_name`/`price`.
  @JsonKey(name: 'membership_id')
  final int membershipId;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory MembershipPlanResponse.fromJson(Map<String, dynamic> json) =>
      _$MembershipPlanResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [MembershipPlan] entity.
  MembershipPlan toDomain() {
    return MembershipPlan(
      id: Id(planId.toString()),
      name: planName,
      price: price,
      membershipId: Id(membershipId.toString()),
    );
  }
}
