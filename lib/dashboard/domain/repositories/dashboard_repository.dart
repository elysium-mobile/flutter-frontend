import '../../../shared/domain/models/id.dart';
import '../models/area_company.dart';
import '../models/climate_diagnosis.dart';
import '../models/company.dart';
import '../models/team_metrics.dart';
import '../models/work_team.dart';

/// Port (hexagonal) describing the HR Analytics data-access capabilities
/// required by the dashboard application layer.
///
/// Expressed purely in terms of domain types: the application layer depends on
/// this contract, never on the concrete network/database adapter that fulfils
/// it. Implementations live in `data/repositories/` and are responsible for
/// bridging the ELYSIUM backend streams into the local Drift cache.
///
/// Operations communicate failure by throwing an [Exception]; the BLoC catches
/// it once and reduces it into a renderable error state.
abstract interface class DashboardRepository {
  /// Loads every company visible to the authenticated HR specialist.
  ///
  /// Implementations refresh the local cache from the backend and fall back to
  /// the cached rows when the network is unavailable.
  Future<List<Company>> loadCompanies();

  /// Loads the functional areas tracked across the organization.
  Future<List<AreaCompany>> loadAreas();

  /// Loads the work teams assigned to the authenticated HR specialist, which
  /// populate the "Choose team" selector.
  Future<List<WorkTeam>> loadAssignedTeams();

  /// Loads the aggregated workforce [TeamMetrics] for the team identified by
  /// [workTeamId], driving the quad-metrics panel and the progress chart.
  Future<TeamMetrics> loadTeamMetrics(Id workTeamId);

  /// Requests an AI climate diagnosis for the company identified by [companyId].
  ///
  /// Wraps `POST /api/v1/dashboard-assistant`: the optional [question] steers
  /// the analysis (a null/blank value runs a general climate diagnosis). This
  /// is a live AI call with no cache fallback — a transport failure surfaces as
  /// an [Exception] the application layer reduces into an error state.
  Future<ClimateDiagnosis> diagnoseClimate({
    required int companyId,
    String? question,
  });
}
