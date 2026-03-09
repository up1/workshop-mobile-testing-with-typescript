# ui

A new Flutter project.

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
  services/
    api_service.dart                # Abstract API interface (login, getMiniApps, logout)
    real_api_service.dart           # HTTP-based real API implementation
    mock_api_service.dart           # In-memory mock (user123/pass123, 2 miniApps)
    api_service_factory.dart        # Factory — returns mock or real based on config
    session_manager.dart            # Holds auth token + user state
  pages/
    home_page.dart                  # Welcome screen → "Go to Login" + "Go to MiniApps"
    login_page.dart                 # Username/password form → navigates to nextRoute
    profile_page.dart               # Shows user info → "Logout" → clears session
    mini_apps_page.dart             # List of miniApps fetched from API → tap to open
    mini_app_webview_page.dart      # WebView displaying selected miniApp URL
  router/
    app_router.dart                 # GoRouter setup with auth redirect guard
test/
  widget_test.dart                  # Smoke test — app starts on home page
  pages/
    home_page_test.dart             # 3 tests (display, keys, navigation)
    login_page_test.dart            # 6 tests (display, keys, validation, success, error, nextRoute)
    profile_page_test.dart          # 3 tests (display, keys, logout)
    mini_apps_page_test.dart        # 7 tests (loading, list, keys, empty, error, nav, logout)
```

## Flows

### Flow 1 — Login → Profile
`Home → /login → (login) → /profile → (logout) → /`

### Flow 2 — Login → MiniApps → WebView
`Home → /login/miniapps → (login) → /miniapps → (tap card) → /miniapps/webview → (logout) → /`

## Key design decisions
* **Mock/Real toggle:** Set `AppConfig.useMockApi = true/false` in `lib/config/app_config.dart` (or in `main()`)
* **Semantic labels:** Every testable widget has a `Key('...')` and `semanticsLabel` for both widget tests (`find.byKey`) and automation tools (Appium, Patrol)
* **Dependency injection:** `ApiService` and `SessionManager` are injected via constructors — easy to swap fakes in tests
* **Mock credentials:** `user123` / `pass123` for the mock API
* **Login nextRoute:** `LoginPage` accepts a `nextRoute` parameter — `/profile` for Flow 1, `/miniapps` for Flow 2

## Semantic keys for testing

### Home page
`home_app_bar_title`, `home_welcome_text`, `home_description_text`, `home_login_button`, `home_miniapps_button`

### Login page
`login_app_bar_title`, `login_title_text`, `login_username_field`, `login_password_field`, `login_submit_button`, `login_error_text`, `login_loading_indicator`

### Profile page
`profile_app_bar_title`, `profile_avatar`, `profile_name_text`, `profile_email_text`, `profile_logout_button`

### MiniApps page
`miniapps_app_bar_title`, `miniapps_logout_button`, `miniapps_list`, `miniapps_loading_indicator`, `miniapps_error_text`, `miniapps_retry_button`, `miniapps_empty_text`, `miniapp_card_{id}`, `miniapp_tile_{id}`, `miniapp_name_{id}`, `miniapp_url_{id}`

### WebView page
`webview_app_bar_title`, `webview_back_button`, `webview_logout_button`, `webview_content`, `webview_loading_indicator`