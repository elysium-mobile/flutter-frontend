import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/membership.dart';
import '../../domain/models/membership_status.dart';

part 'membership_response.g.dart';

/// Inbound network contract describing the membership payload returned by the
/// ELYSIUM `/api/v1/memberships` resource.
///
/// A raw serialization boundary mirroring the snake_case wire schema. Dates
/// arrive as ISO-8601 day strings and are parsed when projecting into the
/// domain. Marked inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class MembershipResponse {
  /// Creates a [MembershipResponse] from its explicit wire fields.
  const MembershipResponse({
    required this.membershipId,
    required this.membershipStart,
    required this.membershipOver,
    required this.membershipStatus,
  });

  /// Server-driven unique identifier of the membership.
  @JsonKey(name: 'membership_id')
  final int membershipId;

  /// Inclusive start date of the membership period (ISO-8601 day string).
  @JsonKey(name: 'membership_start')
  final String membershipStart;

  /// Exclusive end date of the membership period (ISO-8601 day string).
  @JsonKey(name: 'membership_over')
  final String membershipOver;

  /// Raw lifecycle status token (e.g. `ACTIVE`).
  @JsonKey(name: 'membership_status')
  final String membershipStatus;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory MembershipResponse.fromJson(Map<String, dynamic> json) =>
      _$MembershipResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [Membership] entity,
  /// parsing the date strings and normalizing the status token.
  Membership toDomain() {
    return Membership(
      id: Id(membershipId.toString()),
      status: MembershipStatus.fromApi(membershipStatus),
      start: DateTime.tryParse(membershipStart),
      over: DateTime.tryParse(membershipOver),
    );
  }
}
