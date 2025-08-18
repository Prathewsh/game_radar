import 'package:gamesradar/models/platform.dart';

class Game {
  final int id;
  final String name;
  final String? backgroundImage;
  final DateTime? released;
  final double? rating;
  final List<Platform> platforms;
  final String? description;
  final String? website;
  final List<Platform>? stores;

  Game({
    required this.id,
    required this.name,
    this.backgroundImage,
    this.released,
    this.rating,
    required this.platforms,
    this.description,
    this.website,
    this.stores,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      backgroundImage: json['background_image'],
      released: json['released'] != null
          ? DateTime.parse(json['released'])
          : null,
      rating: json['rating']?.toDouble(),
      platforms:
          (json['platforms'] as List<dynamic>?)
              ?.map((platform) => Platform.fromJson(platform['platform']))
              .toList() ??
          [],
      description: json['description_raw'],
      website: json['website'],
      stores: (json['stores'] as List<dynamic>?)
          ?.map((store) => Platform.fromJson(store['store']))
          .toList(),
    );
  }

  String get releaseDate {
    if (released == null) return 'Coming Soon';
    return '${released!.day}/${released!.month}/${released!.year}';
  }

  String get ratingString {
    if (rating == null) return 'N/A';
    return rating!.toStringAsFixed(1);
  }

  copyWith({required String releaseDate}) {}
}
