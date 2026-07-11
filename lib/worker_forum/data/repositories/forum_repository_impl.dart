import '../../domain/models/forum_thread.dart';
import '../../domain/repositories/forum_repository.dart';
import '../models/category_response.dart';
import '../models/forum_response.dart';
import '../models/forum_user_account_response.dart';
import '../models/thread_response.dart';
import '../network/forum_web_service.dart';

/// Resolves the current authenticated account id (the ELYSIUM user-account id),
/// or `null` when no session is active.
///
/// Injected by the composition root so this adapter stays decoupled from the IAM
/// context while still scoping the forum to the caller's company.
typedef AccountIdProvider = int? Function();

/// Concrete [ForumRepository] adapter over the ELYSIUM forum endpoints.
///
/// Enforces the multi-tenant constraint: it resolves the caller's `company_id`
/// from `/user_accounts`, fetches only that company's forum tree, and flattens
/// forums → categories → threads into a single read-only thread list.
class ForumRepositoryImpl implements ForumRepository {
  /// Creates a [ForumRepositoryImpl] bound to its network collaborator and the
  /// current-account resolver.
  ForumRepositoryImpl({
    required ForumWebService webService,
    required AccountIdProvider accountIdProvider,
  })  : _webService = webService, // ignore: prefer_initializing_formals
        _accountIdProvider = accountIdProvider; // ignore: prefer_initializing_formals

  final ForumWebService _webService;
  final AccountIdProvider _accountIdProvider;

  @override
  Future<List<ForumThread>> loadCompanyThreads() async {
    final int? accountId = _accountIdProvider();
    if (accountId == null) {
      throw Exception('No authenticated session to resolve the company.');
    }

    final int companyId = await _resolveCompanyId(accountId);
    final List<ForumResponse> forums =
        await _webService.fetchForumsByCompany(companyId);

    // Single-pass flatten of forums → categories → threads.
    final List<ForumThread> threads = <ForumThread>[];
    for (final ForumResponse forum in forums) {
      for (final CategoryResponse category in forum.categories) {
        for (final ThreadResponse thread in category.threads) {
          threads.add(thread.toDomain());
        }
      }
    }
    return threads;
  }

  /// Resolves the [companyId] bound to [accountId] via the user-accounts list.
  Future<int> _resolveCompanyId(int accountId) async {
    final List<ForumUserAccountResponse> accounts =
        await _webService.fetchUserAccounts();
    for (final ForumUserAccountResponse account in accounts) {
      if (account.userAccountId == accountId) return account.companyId;
    }
    throw Exception('Company could not be resolved for the current account.');
  }
}
