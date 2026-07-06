import 'package:drift/drift.dart' show Value;

import '../../../shared/data/local/app_database.dart';
import '../../../shared/domain/models/id.dart';
import '../../domain/models/area_company.dart';
import '../../domain/models/company.dart';
import '../../domain/models/work_team.dart';

/// Structural mapping from a persisted [CachedCompanyRow] to the pure-domain
/// [Company] entity.
///
/// Keeps the relational boundary out of the domain: the generated Drift data
/// class is translated here rather than inside the entity itself.
extension CachedCompanyRowMapper on CachedCompanyRow {
  /// Rehydrates a domain [Company] from this cached database row.
  Company toDomain() {
    return Company(
      id: Id(companyId),
      name: name,
      ruc: ruc,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
    );
  }
}

/// Structural mapping from a domain [Company] to a database-compatible
/// [CachedCompaniesCompanion] used for typed insertions/updates.
extension CompanyCompanionMapper on Company {
  /// Converts this domain company into a [CachedCompaniesCompanion] payload.
  CachedCompaniesCompanion toCompanion() {
    return CachedCompaniesCompanion(
      companyId: Value(id.value),
      name: Value(name),
      ruc: Value(ruc),
      contactEmail: Value(contactEmail),
      contactPhone: Value(contactPhone),
    );
  }
}

/// Structural mapping from a persisted [CachedAreaCompanyRow] to the pure-domain
/// [AreaCompany] entity.
extension CachedAreaCompanyRowMapper on CachedAreaCompanyRow {
  /// Rehydrates a domain [AreaCompany] from this cached database row.
  AreaCompany toDomain() {
    return AreaCompany(
      id: Id(areaCompanyId),
      name: name,
      annualBudget: annualBudget,
    );
  }
}

/// Structural mapping from a domain [AreaCompany] to a
/// [CachedAreaCompaniesCompanion].
extension AreaCompanyCompanionMapper on AreaCompany {
  /// Converts this domain area into a [CachedAreaCompaniesCompanion] payload.
  CachedAreaCompaniesCompanion toCompanion() {
    return CachedAreaCompaniesCompanion(
      areaCompanyId: Value(id.value),
      name: Value(name),
      annualBudget: Value(annualBudget),
    );
  }
}

/// Structural mapping from a persisted [CachedWorkTeamRow] to the pure-domain
/// [WorkTeam] entity.
extension CachedWorkTeamRowMapper on CachedWorkTeamRow {
  /// Rehydrates a domain [WorkTeam] from this cached database row.
  WorkTeam toDomain() {
    return WorkTeam(
      id: Id(workTeamId),
      teamName: teamName,
      leaderOfTeam: leaderOfTeam,
      unitOfWorkId: Id(unitOfWorkId),
    );
  }
}

/// Structural mapping from a domain [WorkTeam] to a
/// [CachedWorkTeamsCompanion].
extension WorkTeamCompanionMapper on WorkTeam {
  /// Converts this domain work team into a [CachedWorkTeamsCompanion] payload.
  CachedWorkTeamsCompanion toCompanion() {
    return CachedWorkTeamsCompanion(
      workTeamId: Value(id.value),
      teamName: Value(teamName),
      leaderOfTeam: Value(leaderOfTeam),
      unitOfWorkId: Value(unitOfWorkId.value),
    );
  }
}
