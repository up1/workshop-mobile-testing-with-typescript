import '../models/login_response.dart';
import '../models/mini_app.dart';
import '../models/user.dart';
import 'api_service.dart';

/// In-memory mock implementation of [ApiService] for testing.
///
/// Returns hardcoded data without making any network calls.
/// Simulates a small delay to mimic real API latency.
class MockApiService implements ApiService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (username == 'user123' && password == 'pass123') {
      return const LoginResponse(
        token: 'mock_auth_token',
        user: User(
          id: 1,
          name: 'John Doe',
          email: 'john.doe@example.com',
        ),
      );
    }

    throw Exception('Invalid username or password');
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const [
      MiniApp(
        id: 1,
        name: 'MiniApp 1',
        url: 'https://miniapp1.example.com',
      ),
      MiniApp(
        id: 2,
        name: 'MiniApp 2',
        url: 'https://miniapp2.example.com',
      ),
    ];
  }

  @override
  Future<void> logout(String token) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Mock logout always succeeds.
  }
}
