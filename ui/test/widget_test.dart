import 'package:flutter_test/flutter_test.dart';

import 'package:ui/main.dart';
import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';
import 'package:ui/models/product.dart';
import 'package:ui/models/user.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/services/session_manager.dart';

/// A fake API service for the smoke test.
class FakeApiService implements ApiService {
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

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');
}

void main() {
  testWidgets('App starts on home page', (WidgetTester tester) async {
    final apiService = FakeApiService();
    final sessionManager = SessionManager();

    await tester.pumpWidget(MyApp(
      apiService: apiService,
      sessionManager: sessionManager,
    ));

    // Verify home page is displayed.
    expect(find.text('Welcome to the App'), findsOneWidget);
    expect(find.text('Go to Login'), findsOneWidget);
  });
}
