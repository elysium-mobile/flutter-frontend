import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import 'environment_config.dart';

/// Signature of a supplier that resolves the current bearer token, if any.
///
/// Injected into [ApiClient] so the network layer can attach an `Authorization`
/// header without depending on any concrete session store.
typedef AuthTokenProvider = Future<String?> Function();

/// Exception thrown by [ApiClient] when a request fails at the transport layer
/// or the backend answers with a non-success status code.
///
/// Declared alongside the client (infrastructure concern) and never leaks into
/// any `domain/` directory.
class ApiException implements Exception {
  /// Creates an [ApiException].
  const ApiException({
    required this.statusCode,
    required this.uri,
    this.message,
  });

  /// HTTP status code, or `0` when the request never reached the server.
  final int statusCode;

  /// The endpoint that produced the error.
  final Uri uri;

  /// Optional backend-provided or transport-level message.
  final String? message;

  @override
  String toString() =>
      'ApiException(status: $statusCode, uri: $uri, message: $message)';
}

/// Single, centralized HTTP client shared by every bounded context.
///
/// Responsibilities:
/// * Owns the base configuration (host, prefix, timeout), all resolved at build
///   time via `String.fromEnvironment`.
/// * Applies global request interceptors: JSON headers, an optional bearer
///   token resolved through an injected [AuthTokenProvider], and request/response
///   logging.
/// * Normalizes failures into a single [ApiException] type.
///
/// Feature-specific web services compose this client rather than talking to
/// `http` directly, eliminating duplicated transport code.
class ApiClient {
  /// Creates an [ApiClient].
  ///
  /// An [http.Client] may be injected for testing; otherwise the client owns a
  /// default instance (see [dispose]). [tokenProvider] supplies the bearer token
  /// for authenticated calls; [enableLogging] toggles diagnostic logging.
  ApiClient({
    http.Client? httpClient,
    AuthTokenProvider? tokenProvider,
    bool enableLogging = EnvironmentConfig.apiLoggingEnabled,
  })  : _httpClient = httpClient ?? http.Client(),
        _ownsClient = httpClient == null,
        _tokenProvider = tokenProvider, // ignore: prefer_initializing_formals
        _enableLogging = enableLogging; // ignore: prefer_initializing_formals

  final http.Client _httpClient;
  final bool _ownsClient;
  final AuthTokenProvider? _tokenProvider;
  final bool _enableLogging;

  Duration get _timeout => Duration(seconds: EnvironmentConfig.apiTimeoutSeconds);

  /// Performs an authenticated `GET` and returns the decoded JSON object.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
  }) {
    return _send('GET', path, queryParameters: queryParameters);
  }

  /// Performs an authenticated `GET` against an endpoint that returns a JSON
  /// array (e.g. the ELYSIUM collection resources) and returns the decoded list.
  ///
  /// A non-array 2xx body is normalized to an empty list rather than throwing,
  /// keeping list consumers total.
  Future<List<dynamic>> getList(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final decoded = await _sendRaw('GET', path, queryParameters: queryParameters);
    return decoded is List ? decoded : const <dynamic>[];
  }

  /// Performs an authenticated `POST` and returns the decoded JSON object.
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _send('POST', path, body: body);
  }

  /// Performs an authenticated `PUT` and returns the decoded JSON object.
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _send('PUT', path, body: body);
  }

  /// Performs an authenticated `DELETE` and returns the decoded JSON object.
  Future<Map<String, dynamic>> delete(String path) {
    return _send('DELETE', path);
  }

  /// Object-returning request pipeline shared by the JSON-object verbs.
  ///
  /// Delegates transport to [_sendRaw] and normalizes a non-object 2xx body
  /// (e.g. an empty response) into an empty map.
  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final decoded = await _sendRaw(
      method,
      path,
      body: body,
      queryParameters: queryParameters,
    );
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  }

  /// Core transport pipeline shared by every verb.
  ///
  /// Returns the raw decoded JSON value (`Map`, `List`, or `null` for an empty
  /// body) so both object and collection callers can share a single request,
  /// header, timeout and error-normalization path.
  Future<dynamic> _sendRaw(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    final headers = await _buildHeaders();
    final String? encodedBody = body == null ? null : jsonEncode(body);

    _log('--> $method $uri');
    if (encodedBody != null) {
      _log('    body: $encodedBody');
    }

    final http.Response response;
    try {
      response = await _dispatch(method, uri, headers, encodedBody)
          .timeout(_timeout);
    } on SocketException catch (error) {
      throw ApiException(statusCode: 0, uri: uri, message: error.message);
    } on TimeoutException {
      throw ApiException(statusCode: 0, uri: uri, message: 'Request timed out');
    } on http.ClientException catch (error) {
      throw ApiException(statusCode: 0, uri: uri, message: error.message);
    }

    _log('<-- ${response.statusCode} $uri');
    return _decode(response, uri);
  }

  /// Routes the request to the matching [http.Client] method.
  Future<http.Response> _dispatch(
    String method,
    Uri uri,
    Map<String, String> headers,
    String? body,
  ) {
    switch (method) {
      case 'POST':
        return _httpClient.post(uri, headers: headers, body: body);
      case 'PUT':
        return _httpClient.put(uri, headers: headers, body: body);
      case 'DELETE':
        return _httpClient.delete(uri, headers: headers, body: body);
      case 'GET':
      default:
        return _httpClient.get(uri, headers: headers);
    }
  }

  /// Builds the absolute [Uri] for [path], honoring the configured prefix.
  Uri _buildUri(String path, Map<String, String>? queryParameters) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(
      '${EnvironmentConfig.apiBaseUrl}${EnvironmentConfig.apiPrefix}$normalizedPath',
    ).replace(queryParameters: queryParameters);
  }

  /// Builds the global request headers, injecting the bearer token when present.
  Future<Map<String, String>> _buildHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = await _tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Decodes a successful response into its raw JSON value (`Map`, `List`, or
  /// `null` for an empty body), or throws a normalized [ApiException].
  dynamic _decode(http.Response response, Uri uri) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    }
    throw ApiException(
      statusCode: status,
      uri: uri,
      message: _extractMessage(response.body),
    );
  }

  /// Best-effort extraction of a backend error message; never throws.
  String? _extractMessage(String rawBody) {
    if (rawBody.isEmpty) return null;
    try {
      final decoded = jsonDecode(rawBody);
      if (decoded is Map<String, dynamic>) {
        return (decoded['message'] ?? decoded['error'])?.toString();
      }
    } on FormatException {
      // Non-JSON body; fall back to the raw text below.
    }
    return rawBody;
  }

  /// Emits a diagnostic log line when logging is enabled.
  void _log(String message) {
    if (_enableLogging) {
      developer.log(message, name: 'ApiClient');
    }
  }

  /// Closes the underlying [http.Client] when this client created it.
  void dispose() {
    if (_ownsClient) {
      _httpClient.close();
    }
  }
}
