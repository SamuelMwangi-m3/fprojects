import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final String? authToken;
  final String? tenantId;

  const ApiClient({required this.baseUrl, this.authToken, this.tenantId});

  Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authToken != null) headers['Authorization'] = 'Bearer $authToken';
    if (tenantId != null) headers['X-Tenant-Id'] = tenantId!;
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return http.get(Uri.parse('$baseUrl$path'), headers: _headers(headers));
  }

  Future<http.Response> post(String path, {Object? body, Map<String, String>? headers}) {
    return http.post(Uri.parse('$baseUrl$path'), headers: _headers(headers), body: jsonEncode(body));
  }

  ApiClient withAuth(String token) => ApiClient(baseUrl: baseUrl, authToken: token, tenantId: tenantId);
  ApiClient withTenant(String tenant) => ApiClient(baseUrl: baseUrl, authToken: authToken, tenantId: tenant);
}


