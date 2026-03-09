/// Application configuration for toggling between real and mock API.
///
/// Set [useMockApi] to `true` to use mock data for testing,
/// or `false` to call the real API endpoints.
class AppConfig {
  AppConfig._();

  /// Toggle between mock API and real API.
  ///
  /// - `true`: uses in-memory mock responses (no network calls).
  /// - `false`: calls the real backend API.
  static bool useMockApi = true;

  /// Base URL for the real API server.
  static String baseUrl = 'https://api.example.com';

  /// Timeout duration for API requests in seconds.
  static int apiTimeoutSeconds = 30;
}
