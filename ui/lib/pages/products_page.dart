import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../services/api_service.dart';

/// Displays a list of products fetched from the API.
///
/// Each product shows its thumbnail, title, and price.
/// Tapping a product navigates to the product detail page.
class ProductsPage extends StatefulWidget {
  /// The API service used to fetch products.
  final ApiService apiService;

  const ProductsPage({
    super.key,
    required this.apiService,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product>? _products;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final products = await widget.apiService.getProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          key: Key('products_app_bar_title'),
          semanticsIdentifier: 'products_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
        leading: Semantics(
          identifier: 'products_back_button',
          child: IconButton(
            key: const Key('products_back_button'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
            tooltip: 'Back to Home',
          ),
        ),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return Center(
        child: Semantics(
          identifier: 'products_loading_indicator',
          child: const CircularProgressIndicator(
            key: Key('products_loading_indicator'),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!,
                key: const Key('products_error_text'),
                semanticsIdentifier: 'products_error_text',
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: 'products_retry_button',
                child: ElevatedButton(
                  key: const Key('products_retry_button'),
                  onPressed: _fetchProducts,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_products == null || _products!.isEmpty) {
      return Center(
        child: Text(
          'No products available',
          key: const Key('products_empty_text'),
          semanticsIdentifier: 'products_empty_text',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      key: const Key('products_list'),
      itemCount: _products!.length,
      itemBuilder: (context, index) {
        final product = _products![index];
        return Semantics(
          identifier: 'product_item_${product.id}',
          container: true,
          child: Card(
            key: Key('product_card_${product.id}'),
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              key: Key('product_tile_${product.id}'),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.thumbnail,
                  key: Key('product_thumbnail_${product.id}'),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 56,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              title: Text(
                product.title,
                key: Key('product_title_${product.id}'),
                semanticsIdentifier: 'product_title_${product.id}',
              ),
              subtitle: Text(
                '\$${product.price.toStringAsFixed(2)}',
                key: Key('product_price_${product.id}'),
                semanticsIdentifier: 'product_price_${product.id}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.go('/products/${product.id}');
              },
            ),
          ),
        );
      },
    );
  }
}
