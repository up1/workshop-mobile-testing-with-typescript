import '../config/app_config.dart';
import 'api_service.dart';
import 'mock_api_service.dart';
import 'real_api_service.dart';

/// Factory that returns the correct [ApiService] implementation
/// based on [AppConfig.useMockApi].
class ApiServiceFactory {
  ApiServiceFactory._();

  /// Returns a [MockApiService] when mock mode is enabled,
  /// otherwise returns a [RealApiService].
  static ApiService create() {
    if (AppConfig.useMockApi) {
      return MockApiService();
    }
    return RealApiService();
  }
}
