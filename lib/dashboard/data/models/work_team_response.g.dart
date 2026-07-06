// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_team_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkTeamResponse _$WorkTeamResponseFromJson(Map<String, dynamic> json) =>
    WorkTeamResponse(
      workTeamId: (json['work_team_id'] as num).toInt(),
      teamName: json['team_name'] as String,
      leaderOfTeam: json['leader_of_team'] as String,
      unitOfWorkId: (json['unit_of_work_id'] as num).toInt(),
    );
