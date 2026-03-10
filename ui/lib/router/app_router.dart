import 'package:go_router/go_router.dart';

import '../models/mini_app.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/mini_app_webview_page.dart';
import '../pages/mini_apps_page.dart';
import '../pages/product_detail_page.dart';
import '../pages/products_page.dart';
import '../pages/profile_page.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

/// Creates the application router for Flow 1 and Flow 2.
///
/// Routes:
/// - `/`                → [HomePage]
/// - `/login`           → [LoginPage] (Flow 1 — navigates to profile)
/// - `/login/miniapps`  → [LoginPage] (Flow 2 — navigates to miniapps)
/// - `/profile`         → [ProfilePage] (requires auth)
/// - `/miniapps`        → [MiniAppsPage] (requires auth)
/// - `/miniapps/webview`→ [MiniAppWebViewPage] (requires auth, extra=MiniApp)
/// - `/products`        → [ProductsPage]
/// - `/products/:id`    → [ProductDetailPage]
GoRouter createRouter({
  required ApiService apiService,
  required SessionManager sessionManager,
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          apiService: apiService,
          sessionManager: sessionManager,
          nextRoute: '/profile',
        ),
      ),
      GoRoute(
        path: '/login/miniapps',
        builder: (context, state) => LoginPage(
          apiService: apiService,
          sessionManager: sessionManager,
          nextRoute: '/miniapps',
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfilePage(
          apiService: apiService,
          sessionManager: sessionManager,
        ),
      ),
      GoRoute(
        path: '/miniapps',
        builder: (context, state) => MiniAppsPage(
          apiService: apiService,
          sessionManager: sessionManager,
        ),
      ),
      GoRoute(
        path: '/miniapps/webview',
        builder: (context, state) {
          final miniApp = state.extra as MiniApp?;
          if (miniApp == null) {
            // Fallback: redirect handled below.
            return MiniAppsPage(
              apiService: apiService,
              sessionManager: sessionManager,
            );
          }
          return MiniAppWebViewPage(
            miniApp: miniApp,
            apiService: apiService,
            sessionManager: sessionManager,
          );
        },
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => ProductsPage(
          apiService: apiService,
        ),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ProductDetailPage(
            productId: id,
            apiService: apiService,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = sessionManager.isLoggedIn;
      final location = state.matchedLocation;

      // Pages that require authentication.
      const protectedPrefixes = ['/profile', '/miniapps'];

      final isProtected = protectedPrefixes.any(
        (prefix) => location.startsWith(prefix),
      );

      if (isProtected && !isLoggedIn) {
        return '/';
      }

      return null;
    },
  );
}
