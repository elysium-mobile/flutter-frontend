import 'package:json_annotation/json_annotation.dart';

import '../../../shared/domain/models/id.dart';
import '../../domain/models/work_team.dart';

part 'work_team_response.g.dart';

/// Inbound network contract describing the work-team payload returned by the
/// ELYSIUM `/api/v1/work-teams` resource.
///
/// A raw serialization boundary mirroring the snake_case wire schema exactly.
/// Deserialization is delegated to the generated `@JsonSerializable` schema;
/// projection into the pure domain layer is exposed through [toDomain]. Marked
/// inbound-only (`createToJson: false`) since the client never serializes this
/// type outward.
@JsonSerializable(createToJson: false)
class WorkTeamResponse {
  /// Creates a [WorkTeamResponse] from its explicit wire fields.
  const WorkTeamResponse({
    required this.workTeamId,
    required this.teamName,
    required this.leaderOfTeam,
    required this.unitOfWorkId,
  });

  /// Server-driven unique identifier of the work team.
  @JsonKey(name: 'work_team_id')
  final int workTeamId;

  /// Display name of the team.
  @JsonKey(name: 'team_name')
  final String teamName;

  /// Full name of the person leading the team.
  @JsonKey(name: 'leader_of_team')
  final String leaderOfTeam;

  /// Identifier of the owning unit of work.
  @JsonKey(name: 'unit_of_work_id')
  final int unitOfWorkId;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory WorkTeamResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkTeamResponseFromJson(json);

  /// Projects this raw response onto the pure-domain [WorkTeam] entity, wrapping
  /// the numeric identifiers in the shared [Id] value object.
  WorkTeam toDomain() {
    return WorkTeam(
      id: Id(workTeamId.toString()),
      teamName: teamName,
      leaderOfTeam: leaderOfTeam,
      unitOfWorkId: Id(unitOfWorkId.toString()),
    );
  }
}
