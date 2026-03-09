import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/login_response.dart';
import '../models/mini_app.dart';
import 'api_service.dart';

/// Calls the real backend API over HTTP.
class RealApiService implements ApiService {
  final http.Client _client;

  RealApiService({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<LoginResponse> login(String username, String password) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/api/login');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    ).timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/api/miniapps');
    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = data['miniApps'] as List<dynamic>;
      return list
          .map((e) => MiniApp.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch miniApps: ${response.statusCode}');
    }
  }

  @override
  Future<void> logout(String token) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/api/logout');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: AppConfig.apiTimeoutSeconds));

    if (response.statusCode != 200) {
      throw Exception('Logout failed: ${response.statusCode}');
    }
  }
}
