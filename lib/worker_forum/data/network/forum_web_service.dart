import '../../../shared/data/network/api_client.dart';
import '../models/forum_response.dart';
import '../models/forum_user_account_response.dart';

/// Forum network mappings layered on top of the shared [ApiClient].
///
/// Targets the ELYSIUM `/user_accounts` collection (to resolve the caller's
/// company) and the company-scoped `/forums/company/{companyId}` resource. All
/// transport concerns (headers, bearer token, logging, error normalization) are
/// delegated to the centralized client.
class ForumWebService {
  /// Creates a [ForumWebService] bound to the shared [ApiClient].
  ForumWebService(this._apiClient);

  final ApiClient _apiClient;

  /// Relative endpoint listing every user account (for company resolution).
  static const String _userAccountsPath = '/user_accounts';

  /// Relative endpoint template for a company's forums (nested tree).
  static String _forumsByCompanyPath(int companyId) =>
      '/forums/company/$companyId';

  /// Fetches every user account so the caller's `company_id` can be resolved.
  Future<List<ForumUserAccountResponse>> fetchUserAccounts() async {
    final json = await _apiClient.getList(_userAccountsPath);
    return json
        .cast<Map<String, dynamic>>()
        .map(ForumUserAccountResponse.fromJson)
        .toList();
  }

  /// Fetches the fully-nested forum tree scoped to [companyId].
  Future<List<ForumResponse>> fetchForumsByCompany(int companyId) async {
    final json = await _apiClient.getList(_forumsByCompanyPath(companyId));
    return json
        .cast<Map<String, dynamic>>()
        .map(ForumResponse.fromJson)
        .toList();
  }
}
