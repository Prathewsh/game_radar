class Game {
  final String slug;
  final String name;
  final int playtime;
  final List<PlatformModel> platforms;
  final List<StoreInfo> stores;
  final String releaseDate;
  final bool tba;
  final String? backgroundImage;
  final String ratingString;
  final int ratingTop;
  final List<dynamic> ratings;
  final int ratingsCount;
  final int reviewsTextCount;
  final int added;
  final AddedByStatus? addedByStatus;
  final int? metacritic;
  final int suggestionsCount;
  final String updated;
  final int id;
  final dynamic score;
  final dynamic clip;
  final List<dynamic> tags;
  final dynamic esrbRating;
  final dynamic userGame;
  final int reviewsCount;
  final int communityRating;
  final String saturatedColor;
  final String dominantColor;
  final List<ShortScreenshot> shortScreenshots;
  final List<ParentPlatform> parentPlatforms;
  final List<Genre> genres;
  final String? description;
  final String? website;

  Game({
    required this.slug,
    required this.name,
    required this.playtime,
    required this.platforms,
    required this.stores,
    required this.releaseDate,
    required this.tba,
    required this.backgroundImage,
    required this.ratingString,
    required this.ratingTop,
    required this.ratings,
    required this.ratingsCount,
    required this.reviewsTextCount,
    required this.added,
    required this.addedByStatus,
    required this.metacritic,
    required this.suggestionsCount,
    required this.updated,
    required this.id,
    required this.score,
    required this.clip,
    required this.tags,
    required this.esrbRating,
    required this.userGame,
    required this.reviewsCount,
    required this.communityRating,
    required this.saturatedColor,
    required this.dominantColor,
    required this.shortScreenshots,
    required this.parentPlatforms,
    required this.genres,
    required this.description,
    required this.website,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      slug: json['slug'] as String,
      name: json['name'] as String,
      playtime: json['playtime'] as int,
      platforms:
          (json['platforms'] as List?)
              ?.map((e) => PlatformModel.fromJson(e['platform']))
              .toList() ??
          [],
      stores:
          (json['stores'] as List?)
              ?.map((e) => StoreInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      releaseDate: json['released'] as String,
      tba: json['tba'] as bool,
      backgroundImage: json['background_image'],
      ratingString: (json['rating']).toString(),
      ratingTop: json['rating_top'] as int,
      ratings: json['ratings'] as List<dynamic>,
      ratingsCount: json['ratings_count'] as int,
      reviewsTextCount: json['reviews_text_count'] as int,
      added: json['added'] as int,
      addedByStatus: json['added_by_status'] == null
          ? null
          : AddedByStatus.fromJson(
              json['added_by_status'] as Map<String, dynamic>,
            ),
      metacritic: json['metacritic'] as int?,
      suggestionsCount: json['suggestions_count'] as int,
      updated: json['updated'] as String,
      id: json['id'] as int,
      score: json['score'],
      clip: json['clip'],
      tags: json['tags'] as List<dynamic>,
      esrbRating: json['esrb_rating'],
      userGame: json['user_game'],
      reviewsCount: json['reviews_count'] as int,
      communityRating: json['community_rating'] ?? 0,
      saturatedColor: json['saturated_color'] as String,
      dominantColor: json['dominant_color'] as String,
      shortScreenshots:
          (json['short_screenshots'] as List?)
              ?.map((e) => ShortScreenshot.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      parentPlatforms:
          (json['parent_platforms'] as List?)
              ?.map((e) => ParentPlatform.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      genres:
          (json['genres'] as List?)
              ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description_raw'],
      website: json['website'],
    );
  }
}

class PlatformModel {
  final int id;
  final String name;
  final String slug;

  PlatformModel({required this.id, required this.name, required this.slug});

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

class StoreInfo {
  final Store store;

  StoreInfo({required this.store});

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(store: Store.fromJson(json['store']));
  }
}

class Store {
  final int id;
  final String name;
  final String slug;

  Store({required this.id, required this.name, required this.slug});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

class AddedByStatus {
  final int yet;
  final int owned;
  final int toplay;

  AddedByStatus({required this.yet, required this.owned, required this.toplay});

  factory AddedByStatus.fromJson(Map<String, dynamic> json) {
    return AddedByStatus(
      yet: json['yet'] ?? 0,
      owned: json['owned'] ?? 0,
      toplay: json['toplay'] ?? 0,
    );
  }
}

class ShortScreenshot {
  final int id;
  final String image;

  ShortScreenshot({required this.id, required this.image});

  factory ShortScreenshot.fromJson(Map<String, dynamic> json) {
    return ShortScreenshot(
      id: json['id'] as int,
      image: json['image'] as String,
    );
  }
}

class ParentPlatform {
  final PlatformModel platform;

  ParentPlatform({required this.platform});

  factory ParentPlatform.fromJson(Map<String, dynamic> json) {
    return ParentPlatform(platform: PlatformModel.fromJson(json['platform']));
  }
}

class Genre {
  final int id;
  final String name;
  final String slug;

  Genre({required this.id, required this.name, required this.slug});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}

// import 'dart:convert';

// import 'package:gamesradar/models/platform.dart';

// class Game {
//   final int id;
//   final String name;
//   final String? backgroundImage;
//   final DateTime? released;
//   final double? rating;
//   final List<PlatformModel> platforms;
//   final String? description;
//   final String? website;
//   final List<PlatformModel>? stores;

//   Game({
//     required this.id,
//     required this.name,
//     this.backgroundImage,
//     this.released,
//     this.rating,
//     required this.platforms,
//     this.description,
//     this.website,
//     this.stores,
//   });

//   factory Game.fromJson(Map<String, dynamic> json) {
//     return Game(
//       id: json['id'],
//       name: json['name'],
//       backgroundImage: json['background_image'],
//       released: json['released'] != null
//           ? DateTime.parse(json['released'])
//           : null,
//       rating: json['rating']?.toDouble(),
//       platforms:
//           (json['platforms'] as List<dynamic>?)
//               ?.map((platform) => PlatformModel.fromJson(platform['platform']))
//               .toList() ??
//           [],
//       description: json['description_raw'],
//       website: json['website'],
//       stores: (json['stores'] as List<dynamic>?)
//           ?.map((store) => PlatformModel.fromJson(store['store']))
//           .toList(),
//     );
//   }

//   String get releaseDate {
//     if (released == null) return 'Coming Soon';
//     return '${released!.day}/${released!.month}/${released!.year}';
//   }

//   String get ratingString {
//     if (rating == null) return 'N/A';
//     return rating!.toStringAsFixed(1);
//   }

//   copyWith({required String releaseDate}) {}
// }
