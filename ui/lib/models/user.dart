/// Represents a user returned from the API after authentication.
class User {
  /// Unique identifier for the user.
  final int id;

  /// Display name of the user.
  final String name;

  /// Email address of the user.
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Creates a [User] from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  /// Converts this [User] to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
