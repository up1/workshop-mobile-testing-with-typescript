import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/pages/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('displays welcome text and login button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify the welcome text is displayed.
      expect(find.text('Welcome to the App'), findsOneWidget);
      expect(find.text('Please login to continue'), findsOneWidget);

      // Verify the login button is present.
      expect(find.text('Go to Login'), findsOneWidget);
    });

    testWidgets('has correct semantic labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomePage(),
        ),
      );

      // Verify keys are set for testing.
      expect(
        find.byKey(const Key('home_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('home_welcome_text')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('home_description_text')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('home_login_button')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to login page on button tap', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Scaffold(
              body: Text('Login Page'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: router),
      );

      await tester.tap(find.text('Go to Login'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
