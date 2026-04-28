import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(DemoAuthApp(authService: BiometricAuthService()));
}

class DemoAuthApp extends StatelessWidget {
  const DemoAuthApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Auth App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(authService: authService),
    );
  }
}
