import '../../../shared/data/network/api_client.dart';
import '../models/area_company_response.dart';
import '../models/company_response.dart';
import '../models/work_team_response.dart';

/// Dashboard network mappings layered on top of the shared [ApiClient].
///
/// This thin service targets the ELYSIUM `/api/v1/companies`, `/area-company`
/// and `/work-teams` collection resources and decodes their JSON-array payloads
/// into the corresponding `*Response` types. All transport concerns (headers,
/// bearer token, logging, error normalization) are delegated to the centralized
/// client, so no `http` code is duplicated here.
class DashboardWebService {
  /// Creates a [DashboardWebService] bound to the shared [ApiClient].
  DashboardWebService(this._apiClient);

  final ApiClient _apiClient;

  /// Relative endpoint listing every company.
  static const String _companiesPath = '/companies';

  /// Relative endpoint listing every functional area (note the singular route).
  static const String _areaCompaniesPath = '/area-company';

  /// Relative endpoint listing every work team.
  static const String _workTeamsPath = '/work-teams';

  /// Fetches the full list of companies as raw [CompanyResponse] payloads.
  Future<List<CompanyResponse>> fetchCompanies() async {
    final json = await _apiClient.getList(_companiesPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(CompanyResponse.fromJson)
        .toList();
  }

  /// Fetches the full list of functional areas as [AreaCompanyResponse]
  /// payloads.
  Future<List<AreaCompanyResponse>> fetchAreaCompanies() async {
    final json = await _apiClient.getList(_areaCompaniesPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(AreaCompanyResponse.fromJson)
        .toList();
  }

  /// Fetches the full list of work teams as [WorkTeamResponse] payloads.
  Future<List<WorkTeamResponse>> fetchWorkTeams() async {
    final json = await _apiClient.getList(_workTeamsPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(WorkTeamResponse.fromJson)
        .toList();
  }
}
