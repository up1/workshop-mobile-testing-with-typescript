import '../models/login_response.dart';
import '../models/mini_app.dart';

/// Abstract interface for API calls.
///
/// Implementations include [RealApiService] for live backend calls
/// and [MockApiService] for in-memory testing data.
abstract class ApiService {
  /// Authenticates a user with [username] and [password].
  ///
  /// Returns a [LoginResponse] containing the auth token and user data.
  /// Throws an [Exception] if credentials are invalid or a network
  /// error occurs.
  Future<LoginResponse> login(String username, String password);

  /// Fetches the list of available miniApps.
  ///
  /// Requires a valid [token] for authorization.
  /// Returns a list of [MiniApp] objects.
  Future<List<MiniApp>> getMiniApps(String token);

  /// Logs the current user out.
  ///
  /// The [token] is sent to the server so the session can be invalidated.
  Future<void> logout(String token);
}
