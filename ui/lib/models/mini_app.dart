/// Represents a miniApp returned from the API.
class MiniApp {
  /// Unique identifier for the miniApp.
  final int id;

  /// Display name of the miniApp.
  final String name;

  /// URL to load in the webview.
  final String url;

  const MiniApp({
    required this.id,
    required this.name,
    required this.url,
  });

  /// Creates a [MiniApp] from a JSON map.
  factory MiniApp.fromJson(Map<String, dynamic> json) {
    return MiniApp(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Converts this [MiniApp] to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
      };
}
