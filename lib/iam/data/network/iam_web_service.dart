import '../../../shared/data/network/api_client.dart';
import '../models/authenticated_user_account_response.dart';
import '../models/google_authentication_response.dart';
import 'requests/google_rrhh_sign_up_request.dart';
import 'requests/google_sign_in_request.dart';
import 'requests/rrhh_profile_sign_up_request.dart';
import 'requests/sign_in_request.dart';

/// IAM network mappings layered on top of the shared [ApiClient].
///
/// Targets the ELYSIUM `/api/v1/authentication/**` endpoints (email/password
/// sign-in, classic RRHH sign-up, and the two-phase Google flow), decoding the
/// responses into the corresponding `*Response` types. All transport concerns
/// (headers, bearer token, logging, error normalization) are delegated to the
/// centralized client, so no `http` code is duplicated here.
class IamWebService {
  /// Creates an [IamWebService] bound to the shared [ApiClient].
  IamWebService(this._apiClient);

  final ApiClient _apiClient;

  /// Email/password sign-in endpoint.
  static const String _signInPath = '/authentication/sign-in';

  /// Classic RRHH sign-up endpoint (creates the profile; issues no token).
  static const String _signUpRrhhPath = '/authentication/sign-up/rrhh';

  /// Google identity-check endpoint (phase 1).
  static const String _googlePath = '/authentication/google';

  /// Google RRHH sign-up endpoint (phase 2; issues a session token).
  static const String _signUpRrhhGooglePath =
      '/authentication/sign-up/rrhh/google';

  /// Signs in with email/password, returning the authenticated account session.
  Future<AuthenticatedUserAccountResponse> signIn(SignInRequest request) async {
    final json = await _apiClient.post(_signInPath, body: request.toJson());
    return AuthenticatedUserAccountResponse.fromJson(json);
  }

  /// Registers a new RRHH profile.
  ///
  /// The endpoint returns the created `RRHHProfileResponse` (not a token); the
  /// body is intentionally not decoded, since the session is established through
  /// a follow-up sign-in. A non-2xx status raises an [ApiException].
  Future<void> signUpRrhh(RrhhProfileSignUpRequest request) async {
    await _apiClient.post(_signUpRrhhPath, body: request.toJson());
  }

  /// Runs the Google phase-1 identity check, returning whether an account
  /// already exists (and, if so, the issued session token).
  Future<GoogleAuthenticationResponse> googleAuthenticate(
    GoogleSignInRequest request,
  ) async {
    final json = await _apiClient.post(_googlePath, body: request.toJson());
    return GoogleAuthenticationResponse.fromJson(json);
  }

  /// Completes the Google phase-2 RRHH sign-up, returning the account session.
  Future<AuthenticatedUserAccountResponse> signUpRrhhGoogle(
    GoogleRrhhSignUpRequest request,
  ) async {
    final json =
        await _apiClient.post(_signUpRrhhGooglePath, body: request.toJson());
    return AuthenticatedUserAccountResponse.fromJson(json);
  }
}
