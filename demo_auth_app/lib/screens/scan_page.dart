import 'dart:async';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'profile_page.dart';

/// Simulated biometric scan screen.
///
/// Shows a fingerprint image or a mock camera preview depending on [type],
/// runs a short scanning animation, then forwards the simulated scan result
/// to [authService] for verification.
class ScanPage extends StatefulWidget {
  const ScanPage({
    super.key,
    required this.type,
    required this.authService,
  });

  final BiometricType type;
  final AuthService authService;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

enum _ScanPhase { idle, scanning, verifying, error }

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  _ScanPhase _phase = _ScanPhase.idle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener(_onAnimationStatus);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && _phase == _ScanPhase.scanning) {
      _verify();
    }
  }

  void _startScan() {
    setState(() {
      _phase = _ScanPhase.scanning;
      _errorMessage = null;
    });
    _controller
      ..reset()
      ..forward();
  }

  Future<void> _verify() async {
    setState(() => _phase = _ScanPhase.verifying);
    final result = await widget.authService.authenticate(widget.type);
    if (!mounted) return;

    if (result.success) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ProfilePage(biometricType: widget.type),
        ),
      );
    } else {
      setState(() {
        _phase = _ScanPhase.error;
        _errorMessage = result.message ?? 'Authentication failed';
      });
    }
  }

  String get _title => widget.type == BiometricType.fingerprint
      ? 'Fingerprint Scan'
      : 'Face Scan';

  String get _instruction {
    switch (_phase) {
      case _ScanPhase.idle:
        return widget.type == BiometricType.fingerprint
            ? 'Place your finger on the sensor'
            : 'Position your face in the frame';
      case _ScanPhase.scanning:
        return 'Scanning...';
      case _ScanPhase.verifying:
        return 'Verifying...';
      case _ScanPhase.error:
        return _errorMessage ?? 'Authentication failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: 240,
                height: 240,
                child: widget.type == BiometricType.fingerprint
                    ? _FingerprintView(progress: _controller)
                    : _CameraView(progress: _controller),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              _instruction,
              key: const Key('scanStatusText'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _phase == _ScanPhase.error
                        ? Theme.of(context).colorScheme.error
                        : null,
                  ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              key: const Key('startScanButton'),
              onPressed: (_phase == _ScanPhase.scanning ||
                      _phase == _ScanPhase.verifying)
                  ? null
                  : _startScan,
              icon: const Icon(Icons.touch_app),
              label: Text(_phase == _ScanPhase.error ? 'Try again' : 'Scan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pulsing fingerprint icon with a horizontal scan line that sweeps
/// across while [progress] animates from 0 → 1.
class _FingerprintView extends StatelessWidget {
  const _FingerprintView({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.08),
              ),
            ),
            Icon(Icons.fingerprint, size: 180, color: color),
            if (progress.value > 0 && progress.value < 1)
              Positioned(
                top: 30 + 180 * progress.value,
                left: 30,
                right: 30,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: color,
                    boxShadow: [
                      BoxShadow(color: color, blurRadius: 8, spreadRadius: 1),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Mock camera preview frame for face scan with a sweeping scan line.
class _CameraView extends StatelessWidget {
  const _CameraView({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.face, size: 140, color: Colors.white70),
              if (progress.value > 0 && progress.value < 1)
                Positioned(
                  top: 16 + 200 * progress.value,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          color: color,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                left: 8,
                child: Text(
                  'CAMERA',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
