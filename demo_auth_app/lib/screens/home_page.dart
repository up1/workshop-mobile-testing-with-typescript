import 'package:flutter/material.dart';

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
