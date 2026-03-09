import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/mini_app.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

/// Displays the list of available miniApps.
///
/// Fetches miniApps from the API and lets the user open one in a webview.
/// Provides a logout button in the app bar.
class MiniAppsPage extends StatefulWidget {
  /// The API service used to fetch miniApps and call logout.
  final ApiService apiService;

  /// The session manager that holds current login state.
  final SessionManager sessionManager;

  const MiniAppsPage({
    super.key,
    required this.apiService,
    required this.sessionManager,
  });

  @override
  State<MiniAppsPage> createState() => _MiniAppsPageState();
}

class _MiniAppsPageState extends State<MiniAppsPage> {
  List<MiniApp>? _miniApps;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMiniApps();
  }

  Future<void> _fetchMiniApps() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = widget.sessionManager.token;
      if (token == null) {
        throw Exception('Not authenticated');
      }
      final miniApps = await widget.apiService.getMiniApps(token);
      if (mounted) {
        setState(() {
          _miniApps = miniApps;
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
        title: const Text(
          'MiniApps',
          key: Key('miniapps_app_bar_title'),
          semanticsLabel: 'miniapps_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('miniapps_logout_button'),
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          key: Key('miniapps_loading_indicator'),
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
                key: const Key('miniapps_error_text'),
                semanticsLabel: 'miniapps_error_text',
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('miniapps_retry_button'),
                onPressed: _fetchMiniApps,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_miniApps == null || _miniApps!.isEmpty) {
      return Center(
        child: Text(
          'No miniApps available',
          key: const Key('miniapps_empty_text'),
          semanticsLabel: 'miniapps_empty_text',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      key: const Key('miniapps_list'),
      itemCount: _miniApps!.length,
      itemBuilder: (context, index) {
        final miniApp = _miniApps![index];
        return Card(
          key: Key('miniapp_card_${miniApp.id}'),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            key: Key('miniapp_tile_${miniApp.id}'),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                '${miniApp.id}',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            title: Text(
              miniApp.name,
              key: Key('miniapp_name_${miniApp.id}'),
              semanticsLabel: 'miniapp_name_${miniApp.id}',
            ),
            subtitle: Text(
              miniApp.url,
              key: Key('miniapp_url_${miniApp.id}'),
              semanticsLabel: 'miniapp_url_${miniApp.id}',
              style: theme.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.go(
                '/miniapps/webview',
                extra: miniApp,
              );
            },
          ),
        );
      },
    );
  }
}
