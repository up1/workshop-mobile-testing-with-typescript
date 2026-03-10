import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';
import 'package:ui/models/product.dart';
import 'package:ui/pages/product_detail_page.dart';
import 'package:ui/services/api_service.dart';

/// Fake API that returns a product by id.
class FakeApiServiceWithProduct implements ApiService {
  @override
  Future<Product> getProduct(int id) async {
    return const Product(
      id: 1,
      title: 'Essence Mascara Lash Princess',
      price: 9.99,
      thumbnail: 'https://example.com/thumbnail1.png',
    );
  }

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<LoginResponse> login(String username, String password) async =>
      throw Exception('Not implemented');

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

/// Fake API that throws on getProduct.
class FakeApiServiceProductError implements ApiService {
  @override
  Future<Product> getProduct(int id) async {
    throw Exception('Product not found');
  }

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<LoginResponse> login(String username, String password) async =>
      throw Exception('Not implemented');

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

void main() {
  group('ProductDetailPage', () {
    Widget buildProductDetailPage({
      required ApiService apiService,
      int productId = 1,
    }) {
      final router = GoRouter(
        initialLocation: '/products/$productId',
        routes: [
          GoRoute(
            path: '/products',
            builder: (context, state) => const Scaffold(
              body: Text('Products Page'),
            ),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) {
              final id =
                  int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return ProductDetailPage(
                productId: id,
                apiService: apiService,
              );
            },
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );

      expect(
        find.byKey(const Key('product_detail_loading_indicator')),
        findsOneWidget,
      );
    });

    testWidgets('displays product details after loading', (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Essence Mascara Lash Princess'),
        findsWidgets,
      );
      expect(find.text('\$9.99'), findsOneWidget);
    });

    testWidgets('has correct semantic keys', (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('product_detail_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_detail_back_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_detail_content')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_detail_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_detail_price')),
        findsOneWidget,
      );
    });

    testWidgets('displays error message and retry on failure',
        (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(
          apiService: FakeApiServiceProductError(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('product_detail_error_text')),
        findsOneWidget,
      );
      expect(find.text('Product not found'), findsOneWidget);
      expect(
        find.byKey(const Key('product_detail_retry_button')),
        findsOneWidget,
      );
    });

    testWidgets('displays default title before loading completes',
        (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );

      // Before loading finishes, the app bar should show the default.
      expect(find.text('Product Detail'), findsOneWidget);
    });

    testWidgets('updates app bar title after loading', (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );
      await tester.pumpAndSettle();

      // The app bar title should show the product name.
      expect(
        find.byKey(const Key('product_detail_app_bar_title')),
        findsOneWidget,
      );
      // Title appears in both app bar and body.
      expect(
        find.text('Essence Mascara Lash Princess'),
        findsWidgets,
      );
    });

    testWidgets('navigates back to products list on back button tap',
        (tester) async {
      await tester.pumpWidget(
        buildProductDetailPage(apiService: FakeApiServiceWithProduct()),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('product_detail_back_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Products Page'), findsOneWidget);
    });
  });
}
