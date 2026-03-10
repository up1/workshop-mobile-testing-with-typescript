import '../models/login_response.dart';
import '../models/mini_app.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'api_service.dart';

/// In-memory mock implementation of [ApiService] for testing.
///
/// Returns hardcoded data without making any network calls.
/// Simulates a small delay to mimic real API latency.
class MockApiService implements ApiService {
  @override
  Future<LoginResponse> login(String username, String password) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (username == 'user123' && password == 'pass123') {
      return const LoginResponse(
        token: 'mock_auth_token',
        user: User(
          id: 1,
          name: 'John Doe',
          email: 'john.doe@example.com',
        ),
      );
    }

    throw Exception('Invalid username or password');
  }

  @override
  Future<List<MiniApp>> getMiniApps(String token) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const [
      MiniApp(
        id: 1,
        name: 'MiniApp 1',
        url: 'https://demo-web-hello-form.vercel.app/',
      ),
      MiniApp(
        id: 2,
        name: 'MiniApp 2',
        url: 'https://miniapp2.example.com',
      ),
    ];
  }

  @override
  Future<void> logout(String token) async {
    // Simulate network delay.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    // Mock logout always succeeds.
  }

  @override
  Future<List<Product>> getProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return const [
      Product(
        id: 1,
        title: 'Essence Mascara Lash Princess',
        price: 9.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png',
      ),
      Product(
        id: 2,
        title: 'Eyeshadow Palette with Mirror',
        price: 19.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png',
      ),
      Product(
        id: 3,
        title: 'Powder Canister',
        price: 14.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Powder%20Canister/thumbnail.png',
      ),
      Product(
        id: 4,
        title: 'Lipstick Set',
        price: 29.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Lipstick%20Set/thumbnail.png',
      ),
      Product(
        id: 5,
        title: 'Nail Polish Set',
        price: 24.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Nail%20Polish%20Set/thumbnail.png',
      ),
      Product(
        id: 6,
        title: 'Facial Cleanser',
        price: 12.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Facial%20Cleanser/thumbnail.png',
      ),
      Product(
        id: 7,
        title: 'Moisturizing Cream',
        price: 18.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Moisturizing%20Cream/thumbnail.png',
      ),
      Product(
        id: 8,
        title: 'Sunscreen Lotion',
        price: 15.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Sunscreen%20Lotion/thumbnail.png',
      ),
      Product(
        id: 9,
        title: 'Anti-Aging Serum',
        price: 34.99,
        thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Anti-Aging%20Serum/thumbnail.png',
      ),
      Product(
        id: 10,
        title: 'Gucci Bloom Eau de',
        price: 79.99,
        thumbnail: 'https://cdn.dummyjson.com/product-images/fragrances/gucci-bloom-eau-de/thumbnail.webp',
      ),
    ];
  }

  @override
  Future<Product> getProduct(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final products = await getProducts();
    return products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }
}
