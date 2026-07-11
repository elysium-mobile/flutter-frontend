import '../../../shared/data/local/app_database.dart';
import '../../../shared/data/network/api_client.dart';
import '../../../shared/domain/models/id.dart';
import '../../domain/models/area_company.dart';
import '../../domain/models/climate_diagnosis.dart';
import '../../domain/models/company.dart';
import '../../domain/models/team_metrics.dart';
import '../../domain/models/work_team.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/db_mapping_extensions.dart';
import '../network/dashboard_web_service.dart';
import '../network/requests/analyze_dashboard_request.dart';

/// Concrete [DashboardRepository] adapter bridging the ELYSIUM network streams
/// directly into the local Drift cache.
///
/// Each loader follows the same resilient policy: refresh from the backend and
/// mirror the result into the corresponding Drift table, or — when the network
/// is unavailable ([ApiException]) — fall back to the last-known cached rows.
/// The freshly cached companions and the cold-read rows both round-trip through
/// the `db_mapping_extensions` so the domain layer only ever sees pure entities.
class DashboardRepositoryImpl implements DashboardRepository {
  /// Creates a [DashboardRepositoryImpl] bound to its network and cache
  /// collaborators.
  DashboardRepositoryImpl({
    required DashboardWebService webService,
    required AppDatabase database,
  })  : _webService = webService, // ignore: prefer_initializing_formals
        _database = database; // ignore: prefer_initializing_formals

  final DashboardWebService _webService;
  final AppDatabase _database;

  @override
  Future<List<Company>> loadCompanies() async {
    try {
      final responses = await _webService.fetchCompanies();
      final companies = responses.map((r) => r.toDomain()).toList();
      await _database.cacheCompanies(
        companies.map((c) => c.toCompanion()).toList(),
      );
      return companies;
    } on ApiException {
      final rows = await _database.readCompanies();
      if (rows.isEmpty) rethrow;
      return rows.map((r) => r.toDomain()).toList();
    }
  }

  @override
  Future<List<AreaCompany>> loadAreas() async {
    try {
      final responses = await _webService.fetchAreaCompanies();
      final areas = responses.map((r) => r.toDomain()).toList();
      await _database.cacheAreaCompanies(
        areas.map((a) => a.toCompanion()).toList(),
      );
      return areas;
    } on ApiException {
      final rows = await _database.readAreaCompanies();
      if (rows.isEmpty) rethrow;
      return rows.map((r) => r.toDomain()).toList();
    }
  }

  @override
  Future<List<WorkTeam>> loadAssignedTeams() async {
    try {
      final responses = await _webService.fetchWorkTeams();
      final teams = responses.map((r) => r.toDomain()).toList();
      await _database.cacheWorkTeams(
        teams.map((t) => t.toCompanion()).toList(),
      );
      return teams;
    } on ApiException {
      final rows = await _database.readWorkTeams();
      if (rows.isEmpty) rethrow;
      return rows.map((r) => r.toDomain()).toList();
    }
  }

  @override
  Future<TeamMetrics> loadTeamMetrics(Id workTeamId) async {
    // The ELYSIUM backend currently exposes no aggregate team-metrics endpoint
    // (there is no resource that bundles wellbeing, membership, forum reports
    // and completed surveys for a work team). Rather than fabricate values, the
    // adapter returns a truthful zeroed snapshot until that endpoint lands — a
    // documented integration gap, mirroring the IAM auth-bridge gap. The full
    // presentation and state pipeline is already wired to consume real metrics
    // the moment the contract becomes available.
    return const TeamMetrics.empty();
  }

  @override
  Future<ClimateDiagnosis> diagnoseClimate({
    required int companyId,
    String? question,
  }) async {
    // Live AI call: no cache fallback. The normalized negation of a null/blank
    // question keeps the wire payload clean (an absent key runs the general
    // diagnosis server-side). Any [ApiException] propagates for the bloc to
    // reduce into an error state.
    final String? trimmed = question?.trim();
    final response = await _webService.analyzeDashboard(
      AnalyzeDashboardRequest(
        companyId: companyId,
        question: (trimmed == null || trimmed.isEmpty) ? null : trimmed,
      ),
    );
    return response.toDomain();
  }
}
