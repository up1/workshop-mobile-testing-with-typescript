import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/auth_service.dart';
import 'scan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.authService});

  final AuthService authService;

  void _openScan(BuildContext context, BiometricType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ScanPage(type: type, authService: authService),
      ),
    );
  }

  Future<void> _openWebBrowser(BuildContext context) async {
    final Uri url = Uri.parse('https://www.google.com');
    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open browser')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo Auth App')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign in with biometrics',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _BiometricButton(
              key: const Key('fingerprintButton'),
              icon: Icons.fingerprint,
              label: 'Authenticate with Fingerprint',
              identifier: 'fingerprint_button',
              onPressed: () => _openScan(context, BiometricType.fingerprint),
            ),
            const SizedBox(height: 16),
            _BiometricButton(
              key: const Key('faceScanButton'),
              icon: Icons.face,
              label: 'Authenticate with Face Scan',
              identifier: 'facescan_button',
              onPressed: () => _openScan(context, BiometricType.face),
            ),
            const SizedBox(height: 16),
            _BiometricButton(
              key: const Key('openBrowserButton'),
              icon: Icons.public,
              label: 'Open Web Browser',
              identifier: 'open_browser_button',
              onPressed: () => _openWebBrowser(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricButton extends StatelessWidget {
  const _BiometricButton({
    super.key,
    required this.icon,
    required this.label,
    required this.identifier,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final String identifier;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: identifier,
      label: label,
      excludeSemantics: true,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
