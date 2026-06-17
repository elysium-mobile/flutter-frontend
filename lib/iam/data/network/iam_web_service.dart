import '../../../shared/data/network/api_client.dart';
import '../models/auth_session_dto.dart';
import 'requests/register_request.dart';
import 'requests/sign_in_request.dart';

/// IAM network mappings layered on top of the shared [ApiClient].
///
/// This thin service maps feature request DTOs to endpoint calls and decodes the
/// responses into [AuthSessionDto]. All transport concerns (headers, tokens,
/// logging, error normalization) are delegated to the centralized client, so no
/// `http` code is duplicated here.
class IamWebService {
  /// Creates an [IamWebService] bound to the shared [ApiClient].
  IamWebService(this._apiClient);

  final ApiClient _apiClient;

  /// Relative endpoint that exchanges an ID token for a session.
  static const String _sessionsPath = '/iam/sessions';

  /// Relative endpoint that provisions new employee accounts.
  static const String _usersPath = '/iam/users';

  /// Exchanges a verified Firebase ID token (wrapped in [request]) for a
  /// first-party [AuthSessionDto].
  Future<AuthSessionDto> authenticate(SignInRequest request) async {
    final json = await _apiClient.post(_sessionsPath, body: request.toJson());
    return AuthSessionDto.fromJson(json);
  }

  /// Provisions a new employee account described by [request].
  Future<AuthSessionDto> register(RegisterRequest request) async {
    final json = await _apiClient.post(_usersPath, body: request.toJson());
    return AuthSessionDto.fromJson(json);
  }
}
