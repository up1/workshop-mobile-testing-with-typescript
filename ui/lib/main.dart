import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'router/app_router.dart';
import 'services/api_service.dart';
import 'services/api_service_factory.dart';
import 'services/session_manager.dart';

void main() {
  // Toggle this flag to switch between mock and real API.
  // Set to `false` when pointing at a real backend.
  AppConfig.useMockApi = true;

  // Optionally override the base URL for the real API:
  // AppConfig.baseUrl = 'https://your-real-api.example.com';

  final apiService = ApiServiceFactory.create();
  final sessionManager = SessionManager();

  runApp(MyApp(
    apiService: apiService,
    sessionManager: sessionManager,
  ));
}

/// Root widget of the application.
///
/// Accepts an [ApiService] and [SessionManager] via constructor injection
/// so they can be swapped easily for testing.
class MyApp extends StatelessWidget {
  final ApiService apiService;
  final SessionManager sessionManager;

  const MyApp({
    super.key,
    required this.apiService,
    required this.sessionManager,
  });

  @override
  Widget build(BuildContext context) {
    final router = createRouter(
      apiService: apiService,
      sessionManager: sessionManager,
    );

    return MaterialApp.router(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: router,
    );
  }
}
