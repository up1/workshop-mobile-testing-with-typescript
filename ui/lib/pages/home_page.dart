import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Home page — the entry point of the app.
///
/// Displays a welcome message and a button to navigate to the login page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          key: Key('home_app_bar_title'),
          semanticsLabel: 'home_app_bar_title',
        ),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the App',
                key: const Key('home_welcome_text'),
                semanticsLabel: 'home_welcome_text',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please login to continue',
                key: const Key('home_description_text'),
                semanticsLabel: 'home_description_text',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                key: const Key('home_login_button'),
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.login),
                label: const Text('Go to Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                key: const Key('home_miniapps_button'),
                onPressed: () => context.go('/login/miniapps'),
                icon: const Icon(Icons.apps),
                label: const Text('Go to MiniApps'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
