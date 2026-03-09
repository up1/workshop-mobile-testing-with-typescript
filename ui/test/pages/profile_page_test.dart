import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/models/user.dart';
import 'package:ui/pages/profile_page.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/session_manager.dart';
import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';

/// A fake API service for the profile page tests.
class FakeApiService implements ApiService {
  bool logoutCalled = false;

  @override
  Future<LoginResponse> login(String username, String password) async {
    return const LoginResponse(
      token: 'test_token',
      user: User(id: 1, name: 'Test User', email: 'test@example.com'),
    );
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {
    logoutCalled = true;
  }
}

void main() {
  group('ProfilePage', () {
    late SessionManager sessionManager;
    late FakeApiService fakeApiService;

    setUp(() {
      sessionManager = SessionManager();
      fakeApiService = FakeApiService();

      // Simulate a logged-in user.
      sessionManager.login(
        token: 'test_token',
        user: const User(
          id: 1,
          name: 'John Doe',
          email: 'john.doe@example.com',
        ),
      );
    });

    Widget buildProfilePage() {
      final router = GoRouter(
        initialLocation: '/profile',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Text('Home Page'),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => ProfilePage(
              apiService: fakeApiService,
              sessionManager: sessionManager,
            ),
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('displays user information', (tester) async {
      await tester.pumpWidget(buildProfilePage());

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
      expect(find.text('J'), findsOneWidget); // Avatar initial
    });

    testWidgets('has correct semantic labels', (tester) async {
      await tester.pumpWidget(buildProfilePage());

      expect(
        find.byKey(const Key('profile_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('profile_avatar')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('profile_name_text')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('profile_email_text')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('profile_logout_button')),
        findsOneWidget,
      );
    });

    testWidgets('logout clears session and navigates home', (tester) async {
      await tester.pumpWidget(buildProfilePage());

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(fakeApiService.logoutCalled, isTrue);
      expect(sessionManager.isLoggedIn, isFalse);
      expect(find.text('Home Page'), findsOneWidget);
    });
  });
}
