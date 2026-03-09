import 'user.dart';

/// Represents the response from the login or face-scan API.
///
/// Contains an authentication [token] and the authenticated [user].
class LoginResponse {
  /// The authentication token for subsequent API requests.
  final String token;

  /// The authenticated user data.
  final User user;

  const LoginResponse({
    required this.token,
    required this.user,
  });

  /// Creates a [LoginResponse] from a JSON map.
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
