import 'package:flutter/foundation.dart';

import '../models/user.dart';

/// Manages the current authentication session.
///
/// Stores the auth [token] and [user] data after a successful login,
/// and clears them on logout. Notifies listeners when session state changes.
class SessionManager extends ChangeNotifier {
  String? _token;
  User? _user;

  /// The current authentication token, or `null` if not logged in.
  String? get token => _token;

  /// The currently authenticated user, or `null` if not logged in.
  User? get user => _user;

  /// Whether the user is currently authenticated.
  bool get isLoggedIn => _token != null && _user != null;

  /// Saves login data and notifies listeners.
  void login({required String token, required User user}) {
    _token = token;
    _user = user;
    notifyListeners();
  }

  /// Clears session data and notifies listeners.
  void logout() {
    _token = null;
    _user = null;
    notifyListeners();
  }
}
