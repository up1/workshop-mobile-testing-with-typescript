import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ui/models/login_response.dart';
import 'package:ui/models/mini_app.dart';
import 'package:ui/models/product.dart';
import 'package:ui/pages/products_page.dart';
import 'package:ui/services/api_service.dart';

/// Fake API that returns a list of products.
class FakeApiServiceWithProducts implements ApiService {
  @override
  Future<List<Product>> getProducts() async {
    return const [
      Product(
        id: 1,
        title: 'Essence Mascara Lash Princess',
        price: 9.99,
        thumbnail: 'https://example.com/thumbnail1.png',
      ),
      Product(
        id: 2,
        title: 'Eyeshadow Palette with Mirror',
        price: 19.99,
        thumbnail: 'https://example.com/thumbnail2.png',
      ),
    ];
  }

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');

  @override
  Future<LoginResponse> login(String username, String password) async =>
      throw Exception('Not implemented');

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

/// Fake API that returns an empty product list.
class FakeApiServiceEmptyProducts implements ApiService {
  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');

  @override
  Future<LoginResponse> login(String username, String password) async =>
      throw Exception('Not implemented');

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

/// Fake API that throws on getProducts.
class FakeApiServiceProductsError implements ApiService {
  @override
  Future<List<Product>> getProducts() async {
    throw Exception('Network error');
  }

  @override
  Future<Product> getProduct(int id) async =>
      throw Exception('Not implemented');

  @override
  Future<LoginResponse> login(String username, String password) async =>
      throw Exception('Not implemented');

  @override
  Future<List<MiniApp>> getMiniApps(String token) async => const [];

  @override
  Future<void> logout(String token) async {}
}

void main() {
  group('ProductsPage', () {
    Widget buildProductsPage({required ApiService apiService}) {
      final router = GoRouter(
        initialLocation: '/products',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: Text('Home Page'),
            ),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => ProductsPage(
              apiService: apiService,
            ),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) => Scaffold(
              body: Text(
                'Product Detail ${state.pathParameters['id']}',
              ),
            ),
          ),
        ],
      );

      return MaterialApp.router(routerConfig: router);
    }

    testWidgets('displays loading indicator initially', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceWithProducts()),
      );

      expect(
        find.byKey(const Key('products_loading_indicator')),
        findsOneWidget,
      );
    });

    testWidgets('displays list of products after loading', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceWithProducts()),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('products_list')), findsOneWidget);
      expect(
        find.text('Essence Mascara Lash Princess'),
        findsOneWidget,
      );
      expect(
        find.text('Eyeshadow Palette with Mirror'),
        findsOneWidget,
      );
      expect(find.text('\$9.99'), findsOneWidget);
      expect(find.text('\$19.99'), findsOneWidget);
    });

    testWidgets('has correct semantic keys', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceWithProducts()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('products_app_bar_title')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('products_back_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_card_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_card_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_title_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_title_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_price_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('product_price_2')),
        findsOneWidget,
      );
    });

    testWidgets('displays empty message when no products', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceEmptyProducts()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('products_empty_text')),
        findsOneWidget,
      );
      expect(find.text('No products available'), findsOneWidget);
    });

    testWidgets('displays error message and retry button on failure',
        (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceProductsError()),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('products_error_text')),
        findsOneWidget,
      );
      expect(find.text('Network error'), findsOneWidget);
      expect(
        find.byKey(const Key('products_retry_button')),
        findsOneWidget,
      );
    });

    testWidgets('navigates to product detail on tap', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceWithProducts()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('product_tile_1')));
      await tester.pumpAndSettle();

      expect(find.text('Product Detail 1'), findsOneWidget);
    });

    testWidgets('navigates back to home on back button tap', (tester) async {
      await tester.pumpWidget(
        buildProductsPage(apiService: FakeApiServiceWithProducts()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('products_back_button')));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });
  });
}
