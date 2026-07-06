import '../../../shared/domain/models/id.dart';

/// Immutable core domain entity describing a work team assigned to the
/// authenticated HR specialist and surfaced in the HR Analytics dashboard.
///
/// A work team is the granularity at which the dashboard isolates and tracks
/// workforce metrics. The entity is pure: no annotations, serialization or
/// infrastructure imports, with hand-written value equality.
class WorkTeam {
  /// Creates an immutable [WorkTeam].
  const WorkTeam({
    required this.id,
    required this.teamName,
    required this.leaderOfTeam,
    required this.unitOfWorkId,
  });

  /// Stable unique identifier assigned by the backend (`work_team_id`).
  final Id id;

  /// Display name of the team (e.g. "On Retail - Marketing").
  final String teamName;

  /// Full name of the person leading the team.
  final String leaderOfTeam;

  /// Identifier of the owning unit of work this team belongs to
  /// (`unit_of_work_id`).
  final Id unitOfWorkId;

  /// Returns a copy of this [WorkTeam] overriding only the provided fields.
  WorkTeam copyWith({
    Id? id,
    String? teamName,
    String? leaderOfTeam,
    Id? unitOfWorkId,
  }) {
    return WorkTeam(
      id: id ?? this.id,
      teamName: teamName ?? this.teamName,
      leaderOfTeam: leaderOfTeam ?? this.leaderOfTeam,
      unitOfWorkId: unitOfWorkId ?? this.unitOfWorkId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkTeam &&
        other.id == id &&
        other.teamName == teamName &&
        other.leaderOfTeam == leaderOfTeam &&
        other.unitOfWorkId == unitOfWorkId;
  }

  @override
  int get hashCode =>
      Object.hash(id, teamName, leaderOfTeam, unitOfWorkId);

  @override
  String toString() =>
      'WorkTeam(id: $id, teamName: $teamName, leaderOfTeam: $leaderOfTeam)';
}
