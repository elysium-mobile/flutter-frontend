import 'package:json_annotation/json_annotation.dart';

part 'forum_user_account_response.g.dart';

/// Inbound network contract for a `UserAccountResponse` item, used solely to
/// resolve the authenticated HR manager's `company_id`.
///
/// The ELYSIUM session (`{id, email, token}`) carries no company, so the forum
/// adapter fetches `GET /api/v1/user_accounts` and matches the account by
/// [userAccountId] to read its [companyId]. Only those two fields are declared;
/// the rest of the payload (including the exposed password hash) is ignored.
/// Marked inbound-only (`createToJson: false`).
@JsonSerializable(createToJson: false)
class ForumUserAccountResponse {
  /// Creates a [ForumUserAccountResponse] from its explicit wire fields.
  const ForumUserAccountResponse({
    required this.userAccountId,
    required this.companyId,
  });

  /// Server-driven unique identifier of the user account.
  @JsonKey(name: 'user_account_id')
  final int userAccountId;

  /// Identifier of the company the account belongs to.
  @JsonKey(name: 'company_id')
  final int companyId;

  /// Standard inbound deserialization contract, backed by the generated schema.
  factory ForumUserAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$ForumUserAccountResponseFromJson(json);
}
