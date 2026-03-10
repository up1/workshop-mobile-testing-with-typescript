import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/api_service.dart';
import '../services/session_manager.dart';

/// Profile page that displays the authenticated user's information.
///
/// Shows user name and email, and provides a logout button
/// that clears the session and navigates back to the home page.
class ProfilePage extends StatelessWidget {
  /// The API service used to call the logout endpoint.
  final ApiService apiService;

  /// The session manager that holds current login state.
  final SessionManager sessionManager;

  const ProfilePage({
    super.key,
    required this.apiService,
    required this.sessionManager,
  });

  Future<void> _handleLogout(BuildContext context) async {
    try {
      final token = sessionManager.token;
      if (token != null) {
        await apiService.logout(token);
      }
    } on Exception {
      // Logout failure is non-critical; clear session regardless.
    }

    sessionManager.logout();

    if (context.mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = sessionManager.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          key:  Key('profile_app_bar_title'),
          semanticsIdentifier: 'profile_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'profile_avatar',
                child: CircleAvatar(
                  key: const Key('profile_avatar'),
                  radius: 48,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    user != null && user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                user?.name ?? 'Unknown',
                key: const Key('profile_name_text'),
                semanticsIdentifier: 'profile_name_text',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? '',
                key: const Key('profile_email_text'),
                semanticsIdentifier: 'profile_email_text',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Semantics(
                identifier: 'profile_logout_button',
                label: 'Logout',
                excludeSemantics: true,
                child: ElevatedButton.icon(
                  key: const Key('profile_logout_button'),
                  onPressed: () => _handleLogout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 48),
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
