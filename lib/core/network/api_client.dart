import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mc_express/core/config/app_config.dart';
import 'package:mc_express/core/network/api_exception.dart';
import 'package:mc_express/core/storage/session_store.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, [Map<String, String?> query = const {}]) {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final cleanQuery = {
      for (final entry in query.entries)
        if (entry.value != null) entry.key: entry.value!,
    };
    return uri.replace(queryParameters: cleanQuery.isEmpty ? null : cleanQuery);
  }

  Future<Map<String, String>> _headers() async {
    final token = await SessionStore.instance.token;
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path, {Map<String, String?> query = const {}}) async {
    final response = await _client.get(_uri(path, query), headers: await _headers());
    return _decode(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await _client.post(
      _uri(path),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }
    final message = decoded is Map && decoded['detail'] != null
        ? decoded['detail'].toString()
        : 'No se pudo conectar con MC Express';
    throw ApiException(message, statusCode: response.statusCode);
  }
}
