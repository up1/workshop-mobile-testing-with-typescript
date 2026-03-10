import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';
import 'package:ui/models/product.dart';
import 'package:ui/models/user.dart';
import 'package:ui/pages/login_page.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/session_manager.dart';

/// A fake API service for testing that always succeeds.
class FakeApiServiceSuccess implements ApiService {
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
  Future<void> logout(String token) async {}

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');
}

/// A fake API service for testing that always fails.
class FakeApiServiceFailure implements ApiService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    throw Exception('Invalid username or password');
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');
}

void main() {
  group('LoginPage', () {
    late SessionManager sessionManager;

    setUp(() {
      sessionManager = SessionManager();
    });

    Widget buildLoginPage({required ApiService apiService}) {
      final router = GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Text('Home Page'),
            ),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginPage(
              apiService: apiService,
              sessionManager: sessionManager,
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Scaffold(
              body: Text('Profile Page'),
            ),
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('displays login form fields', (tester) async {
      await tester.pumpWidget(
        buildLoginPage(apiService: FakeApiServiceSuccess()),
      );

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(
        find.byKey(const Key('login_submit_button')),
        findsOneWidget,
      );
    });

    testWidgets('has correct semantic labels', (tester) async {
      await tester.pumpWidget(
        buildLoginPage(apiService: FakeApiServiceSuccess()),
      );

      expect(
        find.byKey(const Key('login_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('login_title_text')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('login_username_field')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('login_password_field')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('login_submit_button')),
        findsOneWidget,
      );
    });

    testWidgets('shows validation errors for empty fields', (tester) async {
      await tester.pumpWidget(
        buildLoginPage(apiService: FakeApiServiceSuccess()),
      );

      // Tap login without filling fields.
      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('navigates to profile on successful login', (tester) async {
      await tester.pumpWidget(
        buildLoginPage(apiService: FakeApiServiceSuccess()),
      );

      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        'user123',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'pass123',
      );

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Profile Page'), findsOneWidget);
      expect(sessionManager.isLoggedIn, isTrue);
    });

    testWidgets('shows error message on login failure', (tester) async {
      await tester.pumpWidget(
        buildLoginPage(apiService: FakeApiServiceFailure()),
      );

      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        'wrong',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'wrong',
      );

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(
        find.text('Invalid username or password'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('login_error_text')),
        findsOneWidget,
      );
      expect(sessionManager.isLoggedIn, isFalse);
    });

    testWidgets(
      'navigates to miniapps on successful login with nextRoute',
      (tester) async {
        final router = GoRouter(
          initialLocation: '/login/miniapps',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Scaffold(
                body: Text('Home Page'),
              ),
            ),
            GoRoute(
              path: '/login/miniapps',
              builder: (context, state) => LoginPage(
                apiService: FakeApiServiceSuccess(),
                sessionManager: sessionManager,
                nextRoute: '/miniapps',
              ),
            ),
            GoRoute(
              path: '/miniapps',
              builder: (context, state) => const Scaffold(
                body: Text('MiniApps Page'),
              ),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));

        await tester.enterText(
          find.byKey(const Key('login_username_field')),
          'user123',
        );
        await tester.enterText(
          find.byKey(const Key('login_password_field')),
          'pass123',
        );

        await tester.tap(find.byKey(const Key('login_submit_button')));
        await tester.pumpAndSettle();

        expect(find.text('MiniApps Page'), findsOneWidget);
        expect(sessionManager.isLoggedIn, isTrue);
      },
    );
  });
}
