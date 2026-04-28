import 'dart:math';

import 'package:demo_auth_app/main.dart';
import 'package:demo_auth_app/screens/profile_page.dart';
import 'package:demo_auth_app/screens/scan_page.dart';
import 'package:demo_auth_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  testWidgets('fingerprint flow opens scan page then profile on success',
      (tester) async {
    final service = MockAuthService(
      random: Random(0),
      delay: Duration.zero,
      successRate: 1.0,
    );

    await tester.pumpWidget(DemoAuthApp(authService: service));

    await tester.tap(find.byKey(const Key('fingerprintButton')));
    await tester.pumpAndSettle();
    expect(find.byType(ScanPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('startScanButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.text('Authenticated via Fingerprint'), findsOneWidget);
  });

  testWidgets('face scan failure shows error on scan page', (tester) async {
    final service = MockAuthService(
      random: Random(0),
      delay: Duration.zero,
      successRate: 0.0,
    );

    await tester.pumpWidget(DemoAuthApp(authService: service));

    await tester.tap(find.byKey(const Key('faceScanButton')));
    await tester.pumpAndSettle();
    expect(find.byType(ScanPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('startScanButton')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsNothing);
    expect(find.textContaining('Face not recognised'), findsOneWidget);
  });
}
