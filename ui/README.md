# ui

A Flutter mobile application with login, miniApp webview, and product catalog features.

## Project structure
```
lib/
  main.dart                         # Entry point — wires mock/real API toggle
  config/
    app_config.dart                 # useMockApi flag + baseUrl config
  models/
    user.dart                       # User data model
    login_response.dart             # Login response model (token + user)
    mini_app.dart                   # MiniApp data model (id, name, url)
    product.dart                    # Product data model (id, title, price, thumbnail)
  services/
    api_service.dart                # Abstract API interface (login, getMiniApps, logout, getProducts, getProduct)
    real_api_service.dart           # HTTP-based real API implementation
    mock_api_service.dart           # In-memory mock (user123/pass123, 2 miniApps, 10 products)
    api_service_factory.dart        # Factory — returns mock or real based on config
    session_manager.dart            # Holds auth token + user state
  pages/
    home_page.dart                  # Welcome screen → "Go to Login" + "Go to MiniApps" + "Go to Products"
    login_page.dart                 # Username/password form → navigates to nextRoute
    profile_page.dart               # Shows user info → "Logout" → clears session
    mini_apps_page.dart             # List of miniApps fetched from API → tap to open
    mini_app_webview_page.dart      # WebView displaying selected miniApp URL + JS channel
    products_page.dart              # List of products from DummyJSON API → tap for detail
    product_detail_page.dart        # Product detail (image, title, price)
  router/
    app_router.dart                 # GoRouter setup with auth redirect guard
test/
  widget_test.dart                  # Smoke test — app starts on home page
  pages/
    home_page_test.dart             # 3 tests (display, keys, navigation)
    login_page_test.dart            # 6 tests (display, keys, validation, success, error, nextRoute)
    profile_page_test.dart          # 3 tests (display, keys, logout)
    mini_apps_page_test.dart        # 7 tests (loading, list, keys, empty, error, nav, logout)
    products_page_test.dart         # 7 tests (loading, list, keys, empty, error, nav to detail, nav back)
    product_detail_page_test.dart   # 7 tests (loading, detail display, keys, error, default title, title update, nav back)
```

## Flows

### Flow 1 — Login → Profile
`Home → /login → (login) → /profile → (logout) → /`

### Flow 2 — Login → MiniApps → WebView
`Home → /login/miniapps → (login) → /miniapps → (tap card) → /miniapps/webview → (logout) → /`

### Flow 4 — Products → Product Detail
`Home → /products → (tap product) → /products/:id → (back) → /products`

## Routes

| Path | Page | Auth required |
|------|------|--------------|
| `/` | HomePage | No |
| `/login` | LoginPage (→ profile) | No |
| `/login/miniapps` | LoginPage (→ miniapps) | No |
| `/profile` | ProfilePage | Yes |
| `/miniapps` | MiniAppsPage | Yes |
| `/miniapps/webview` | MiniAppWebViewPage | Yes |
| `/products` | ProductsPage | No |
| `/products/:id` | ProductDetailPage | No |

## Key design decisions
* **Mock/Real toggle:** Set `AppConfig.useMockApi = true/false` in `lib/config/app_config.dart` (or in `main()`)
* **Semantic identifiers:** Every testable widget has a `Key('...')` and `semanticsIdentifier` / `Semantics(identifier:)` for both widget tests (`find.byKey`) and automation tools (Appium, Patrol)
* **Dependency injection:** `ApiService` and `SessionManager` are injected via constructors — easy to swap fakes in tests
* **Mock credentials:** `user123` / `pass123` for the mock API
* **Login nextRoute:** `LoginPage` accepts a `nextRoute` parameter — `/profile` for Flow 1, `/miniapps` for Flow 2
* **Products API:** Uses [DummyJSON](https://dummyjson.com/products) as external API for product listing and detail
* **WebView JS channel:** `MiniAppWebViewPage` registers a `FlutterChannel` JavaScriptChannel to receive messages from the web page, and sends the logged-in username to the web page via `receiveUsername()` JavaScript call

## API endpoints

| Feature | Endpoint |
|---------|----------|
| Login | `POST /api/login` |
| Logout | `POST /api/logout` |
| MiniApps list | `GET /api/miniapps` |
| Products list | `GET https://dummyjson.com/products?limit=10&select=id,title,price,thumbnail` |
| Product detail | `GET https://dummyjson.com/products/{id}?select=id,title,price,thumbnail` |

## Semantic keys for testing

### Home page
`home_app_bar_title`, `home_welcome_text`, `home_description_text`, `home_login_button`, `home_miniapps_button`, `home_products_button`

### Login page
`login_app_bar_title`, `login_title_text`, `login_username_field`, `login_password_field`, `login_submit_button`, `login_error_text`, `login_loading_indicator`

### Profile page
`profile_app_bar_title`, `profile_avatar`, `profile_name_text`, `profile_email_text`, `profile_logout_button`

### MiniApps page
`miniapps_app_bar_title`, `miniapps_logout_button`, `miniapps_list`, `miniapps_loading_indicator`, `miniapps_error_text`, `miniapps_retry_button`, `miniapps_empty_text`, `miniapp_card_{id}`, `miniapp_tile_{id}`, `miniapp_name_{id}`, `miniapp_url_{id}`

### WebView page
`webview_app_bar_title`, `webview_back_button`, `webview_logout_button`, `webview_content`, `webview_loading_indicator`, `webview_snackbar`, `webview_received_message`

### Products page
`products_app_bar_title`, `products_back_button`, `products_list`, `products_loading_indicator`, `products_error_text`, `products_retry_button`, `products_empty_text`, `product_card_{id}`, `product_tile_{id}`, `product_thumbnail_{id}`, `product_title_{id}`, `product_price_{id}`

### Product detail page
`product_detail_app_bar_title`, `product_detail_back_button`, `product_detail_content`, `product_detail_image`, `product_detail_title`, `product_detail_price`, `product_detail_loading_indicator`, `product_detail_error_text`, `product_detail_retry_button`

## Running

```bash
# Run in mock mode (default)
cd ui && flutter run

# Run tests
flutter test

# Run a specific test file
flutter test test/pages/products_page_test.dart
```