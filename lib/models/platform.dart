// class PlatformModel {
//   final int id;
//   final String name;
//   final String? slug;
//   final String? imageBackground;
//   final int? gamesCount;
//   final int? yearStart;
//   final int? yearEnd;

//   PlatformModel({
//     required this.id,
//     required this.name,
//     this.slug,
//     this.imageBackground,
//     this.gamesCount,
//     this.yearStart,
//     this.yearEnd,
//   });

//   factory PlatformModel.fromJson(Map<String, dynamic> json) {
//     return PlatformModel(
//       id: json['id'],
//       name: json['name'],
//       slug: json['slug'],
//       imageBackground: json['image_background'],
//       gamesCount: json['games_count'],
//       yearStart: json['year_start'],
//       yearEnd: json['year_end'],
//     );
//   }

//   String get yearRange {
//     if (yearStart != null && yearEnd != null) {
//       return '$yearStart-$yearEnd';
//     } else if (yearStart != null) {
//       return 'Since $yearStart';
//     } else if (yearEnd != null) {
//       return 'Until $yearEnd';
//     }
//     return 'Unknown';
//   }

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is PlatformModel &&
//           runtimeType == other.runtimeType &&
//           id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }
