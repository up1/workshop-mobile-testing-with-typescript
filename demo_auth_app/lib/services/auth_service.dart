import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart' hide BiometricType;

/// Type of biometric authentication supported by the app.
enum BiometricType { fingerprint, face }

/// Result returned from an authentication attempt.
class AuthResult {
  const AuthResult({required this.success, this.message});

  final bool success;
  final String? message;
}

/// Abstract authentication service so it can be swapped or composed.
abstract class AuthService {
  Future<AuthResult> authenticate(BiometricType type);
}

/// Thin wrapper around [LocalAuthentication] that triggers the OS-level
/// biometric prompt on the connected device.
class DeviceBiometricPrompt {
  DeviceBiometricPrompt({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> isAvailable() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;
      final enrolled = await _localAuth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  Future<bool> prompt(BiometricType type) async {
    final reason = type == BiometricType.fingerprint
        ? 'Scan your fingerprint to continue'
        : 'Scan your face to continue';
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}

/// Mock authentication service that simulates a biometric result.
///
/// Per the development spec, instead of trusting the device prompt outcome
/// we delegate the success/failure decision to this mock so flows can be
/// exercised consistently during development and testing.
class MockAuthService implements AuthService {
  MockAuthService({
    Random? random,
    FlutterSecureStorage? storage,
    Duration delay = const Duration(milliseconds: 300),
    this.successRate = 0.8,
  })  : _random = random ?? Random(),
        _storage = storage ?? const FlutterSecureStorage(),
        _delay = delay;

  static const String _tokenKey = 'auth_token';

  final Random _random;
  final FlutterSecureStorage _storage;
  final Duration _delay;

  /// Probability (0..1) that authentication succeeds.
  final double successRate;

  @override
  Future<AuthResult> authenticate(BiometricType type) async {
    await Future<void>.delayed(_delay);

    final success = _random.nextDouble() < successRate;
    if (!success) {
      return AuthResult(
        success: false,
        message: type == BiometricType.fingerprint
            ? 'Fingerprint not recognised. Please try again.'
            : 'Face not recognised. Please try again.',
      );
    }

    final token = 'mock-${type.name}-${DateTime.now().millisecondsSinceEpoch}';
    await _storage.write(key: _tokenKey, value: token);
    return const AuthResult(success: true);
  }

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}

/// Composes a real device biometric prompt with the [MockAuthService].
///
/// Flow:
///   1. Trigger the device's fingerprint/face sensor via `local_auth`.
///   2. Once the OS prompt completes, defer to [MockAuthService] to
///      determine the final success/failure (mocked for development).
///
/// If the device sensor isn't available (e.g. simulator without biometrics),
/// the mock service is still used so the flow remains demoable.
class BiometricAuthService implements AuthService {
  BiometricAuthService({
    DeviceBiometricPrompt? devicePrompt,
    MockAuthService? mock,
  })  : _devicePrompt = devicePrompt ?? DeviceBiometricPrompt(),
        _mock = mock ?? MockAuthService();

  final DeviceBiometricPrompt _devicePrompt;
  final MockAuthService _mock;

  @override
  Future<AuthResult> authenticate(BiometricType type) async {
    final available = await _devicePrompt.isAvailable();
    if (available) {
      final completed = await _devicePrompt.prompt(type);
      if (!completed) {
        return AuthResult(
          success: false,
          message: type == BiometricType.fingerprint
              ? 'Fingerprint scan cancelled.'
              : 'Face scan cancelled.',
        );
      }
    }
    return _mock.authenticate(type);
  }
}
