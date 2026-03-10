import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/mini_app.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

/// Displays a miniApp inside a webview.
///
/// Loads the [MiniApp.url] and provides a logout button that clears
/// the session and navigates back to the home page.
class MiniAppWebViewPage extends StatefulWidget {
  /// The miniApp to display.
  final MiniApp miniApp;

  /// The API service used to call the logout endpoint.
  final ApiService apiService;

  /// The session manager that holds current login state.
  final SessionManager sessionManager;

  const MiniAppWebViewPage({
    super.key,
    required this.miniApp,
    required this.apiService,
    required this.sessionManager,
  });

  @override
  State<MiniAppWebViewPage> createState() => _MiniAppWebViewPageState();
}

class _MiniAppWebViewPageState extends State<MiniAppWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: _onMessageReceived,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
              _sendUsernameToWebView();
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      );
    _controller.loadRequest(Uri.parse(widget.miniApp.url));
  }

  void _sendUsernameToWebView() {
    final username = widget.sessionManager.user?.name ?? '';
    if (username.isNotEmpty) {
      _controller.runJavaScript('receiveUsername("$username")');
    }
  }

  void _onMessageReceived(JavaScriptMessage message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('webview_snackbar'),
        content: Text(
          message.message,
          key: const Key('webview_received_message'),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      final token = widget.sessionManager.token;
      if (token != null) {
        await widget.apiService.logout(token);
      }
    } on Exception {
      // Logout failure is non-critical; clear session regardless.
    }

    widget.sessionManager.logout();

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.miniApp.name,
          key: const Key('webview_app_bar_title'),
          semanticsLabel: 'webview_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
        leading: Semantics(
          label: 'webview_back_button',
          child: IconButton(
            key: const Key('webview_back_button'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/miniapps'),
            tooltip: 'Back to MiniApps',
          ),
        ),
        actions: [
          Semantics(
            label: 'webview_logout_button',
            child: IconButton(
              key: const Key('webview_logout_button'),
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            key: const Key('webview_content'),
            controller: _controller,
          ),
          if (_isLoading)
            Center(
              child: Semantics(
                label: 'webview_loading_indicator',
                child: const CircularProgressIndicator(
                  key: Key('webview_loading_indicator'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
