import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../services/api_service.dart';

/// Displays detailed information about a single product.
///
/// Fetches the product by [productId] from the API and shows
/// its thumbnail, title, and price.
class ProductDetailPage extends StatefulWidget {
  /// The ID of the product to display.
  final int productId;

  /// The API service used to fetch product details.
  final ApiService apiService;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.apiService,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final product = await widget.apiService.getProduct(widget.productId);
      if (mounted) {
        setState(() {
          _product = product;
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
        title: Text(
          _product?.title ?? 'Product Detail',
          key: const Key('product_detail_app_bar_title'),
          semanticsIdentifier: 'product_detail_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
        leading: Semantics(
          identifier: 'product_detail_back_button',
          child: IconButton(
            key: const Key('product_detail_back_button'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/products'),
            tooltip: 'Back to Products',
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
          identifier: 'product_detail_loading_indicator',
          child: const CircularProgressIndicator(
            key: Key('product_detail_loading_indicator'),
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
                key: const Key('product_detail_error_text'),
                semanticsIdentifier: 'product_detail_error_text',
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Semantics(
                identifier: 'product_detail_retry_button',
                child: ElevatedButton(
                  key: const Key('product_detail_retry_button'),
                  onPressed: _fetchProduct,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final product = _product!;

    return SingleChildScrollView(
      key: const Key('product_detail_content'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              product.thumbnail,
              key: const Key('product_detail_image'),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  key: const Key('product_detail_title'),
                  semanticsIdentifier: 'product_detail_title',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  key: const Key('product_detail_price'),
                  semanticsIdentifier: 'product_detail_price',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
