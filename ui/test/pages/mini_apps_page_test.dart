import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';
import 'package:ui/models/user.dart';
import 'package:ui/pages/mini_apps_page.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/session_manager.dart';

/// Fake API that returns a list of miniApps.
class FakeApiServiceWithMiniApps implements ApiService {
  bool logoutCalled = false;

  @override
  Future<LoginResponse> login(String username, String password) async {
    return const LoginResponse(
      token: 'test_token',
      user: User(id: 1, name: 'Test User', email: 'test@example.com'),
    );
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async {
    return const [
      MiniApp(id: 1, name: 'MiniApp 1', url: 'https://miniapp1.example.com'),
      MiniApp(id: 2, name: 'MiniApp 2', url: 'https://miniapp2.example.com'),
    ];
  }

  @override
  Future<void> logout(String token) async {
    logoutCalled = true;
  }
}

/// Fake API that returns an empty list.
class FakeApiServiceEmpty implements ApiService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    return const LoginResponse(
      token: 'test_token',
      user: User(id: 1, name: 'Test', email: 'test@test.com'),
    );
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

/// Fake API that throws on getMiniApps.
class FakeApiServiceError implements ApiService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    return const LoginResponse(
      token: 'test_token',
      user: User(id: 1, name: 'Test', email: 'test@test.com'),
    );
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async {
    throw Exception('Network error');
  }

  @override
  Future<void> logout(String token) async {}
}

void main() {
  group('MiniAppsPage', () {
    late SessionManager sessionManager;

    setUp(() {
      sessionManager = SessionManager();
      sessionManager.login(
        token: 'test_token',
        user: const User(
          id: 1,
          name: 'John Doe',
          email: 'john.doe@example.com',
        ),
      );
    });

    Widget buildMiniAppsPage({required ApiService apiService}) {
      final router = GoRouter(
        initialLocation: '/miniapps',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Text('Home Page'),
            ),
          ),
          GoRoute(
            path: '/miniapps',
            builder: (context, state) => MiniAppsPage(
              apiService: apiService,
              sessionManager: sessionManager,
            ),
          ),
          GoRoute(
            path: '/miniapps/webview',
            builder: (context, state) => const Scaffold(
              body: Text('WebView Page'),
            ),
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceWithMiniApps()),
      );

      // The loading indicator should be shown before data arrives.
      expect(
        find.byKey(const Key('miniapps_loading_indicator')),
        findsOneWidget,
      );
    });

    testWidgets('displays list of miniApps after loading', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceWithMiniApps()),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('miniapps_list')), findsOneWidget);
      expect(find.text('MiniApp 1'), findsOneWidget);
      expect(find.text('MiniApp 2'), findsOneWidget);
      expect(
        find.text('https://miniapp1.example.com'),
        findsOneWidget,
      );
      expect(
        find.text('https://miniapp2.example.com'),
        findsOneWidget,
      );
    });

    testWidgets('has correct semantic keys', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceWithMiniApps()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('miniapps_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('miniapps_logout_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('miniapp_card_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('miniapp_card_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('miniapp_name_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('miniapp_name_2')),
        findsOneWidget,
      );
    });

    testWidgets('shows empty text when no miniApps', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceEmpty()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('miniapps_empty_text')),
        findsOneWidget,
      );
      expect(find.text('No miniApps available'), findsOneWidget);
    });

    testWidgets('shows error message on fetch failure', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceError()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('miniapps_error_text')),
        findsOneWidget,
      );
      expect(find.text('Network error'), findsOneWidget);
      expect(
        find.byKey(const Key('miniapps_retry_button')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to webview on miniApp tap', (tester) async {
      await tester.pumpWidget(
        buildMiniAppsPage(apiService: FakeApiServiceWithMiniApps()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('miniapp_tile_1')));
      await tester.pumpAndSettle();

      expect(find.text('WebView Page'), findsOneWidget);
    });

    testWidgets('logout clears session and navigates home', (tester) async {
      final fakeApi = FakeApiServiceWithMiniApps();

      await tester.pumpWidget(
        buildMiniAppsPage(apiService: fakeApi),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('miniapps_logout_button')));
      await tester.pumpAndSettle();

      expect(fakeApi.logoutCalled, isTrue);
      expect(sessionManager.isLoggedIn, isFalse);
      expect(find.text('Home Page'), findsOneWidget);
    });
  });
}
