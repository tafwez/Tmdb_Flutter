class CelebritiesModel {
  CelebritiesModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  final List<Result> results;
  final int? totalPages;
  final int? totalResults;

  factory CelebritiesModel.fromJson(Map<String, dynamic> json){
    return CelebritiesModel(
      page: json["page"],
      results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": results.map((x) => x.toJson()).toList(),
    "total_pages": totalPages,
    "total_results": totalResults,
  };

  @override
  String toString(){
    return "CelebritiesModel(page: $page, results: ${results.length} items, totalPages: $totalPages, totalResults: $totalResults)";
  }
}

class Result {
  Result({
    required this.adult,
    required this.id,
    required this.name,
    required this.originalName,
    required this.mediaType,
    required this.popularity,
    required this.gender,
    required this.knownForDepartment,
    required this.profilePath,
    required this.knownFor,
  });

  final bool? adult;
  final int? id;
  final String? name;
  final String? originalName;
  final String? mediaType;
  final double? popularity;
  final int? gender;
  final String? knownForDepartment;
  final String? profilePath;
  final List<KnownFor> knownFor;

  // Base URL constant
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Helper getters for different image sizes
  String? get profileImageOriginal => profilePath != null ? '$imageBaseUrl/original$profilePath' : null;
  String? get profileImageW500 => profilePath != null ? '$imageBaseUrl/w500$profilePath' : null;
  String? get profileImageW185 => profilePath != null ? '$imageBaseUrl/w185$profilePath' : null;
  String? get profileImageH632 => profilePath != null ? '$imageBaseUrl/h632$profilePath' : null;

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
      adult: json["adult"],
      id: json["id"],
      name: json["name"],
      originalName: json["original_name"],
      mediaType: json["media_type"],
      popularity: json["popularity"]?.toDouble(),
      gender: json["gender"],
      knownForDepartment: json["known_for_department"],
      profilePath: json["profile_path"],
      knownFor: json["known_for"] == null ? [] : List<KnownFor>.from(json["known_for"]!.map((x) => KnownFor.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "id": id,
    "name": name,
    "original_name": originalName,
    "media_type": mediaType,
    "popularity": popularity,
    "gender": gender,
    "known_for_department": knownForDepartment,
    "profile_path": profilePath,
    "known_for": knownFor.map((x) => x.toJson()).toList(),
  };

  @override
  String toString(){
    return "Result(id: $id, name: $name, profilePath: $profilePath)";
  }
}

class KnownFor {
  KnownFor({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.name,
    required this.originalName,
    required this.firstAirDate,
    required this.originCountry,
  });

  final bool? adult;
  final String? backdropPath;
  final int? id;
  final String? title;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final String? posterPath;
  final String? mediaType;
  final List<int> genreIds;
  final double? popularity;
  final DateTime? releaseDate;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;
  final String? name;
  final String? originalName;
  final DateTime? firstAirDate;
  final List<String> originCountry;

  // Base URL constant
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  // Helper getters for poster images
  String? get posterImageOriginal => posterPath != null ? '$imageBaseUrl/original$posterPath' : null;
  String? get posterImageW500 => posterPath != null ? '$imageBaseUrl/w500$posterPath' : null;
  String? get posterImageW342 => posterPath != null ? '$imageBaseUrl/w342$posterPath' : null;
  String? get posterImageW185 => posterPath != null ? '$imageBaseUrl/w185$posterPath' : null;

  // Helper getters for backdrop images
  String? get backdropImageOriginal => backdropPath != null ? '$imageBaseUrl/original$backdropPath' : null;
  String? get backdropImageW1280 => backdropPath != null ? '$imageBaseUrl/w1280$backdropPath' : null;
  String? get backdropImageW780 => backdropPath != null ? '$imageBaseUrl/w780$backdropPath' : null;
  String? get backdropImageW300 => backdropPath != null ? '$imageBaseUrl/w300$backdropPath' : null;

  factory KnownFor.fromJson(Map<String, dynamic> json){
    return KnownFor(
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      id: json["id"],
      title: json["title"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      mediaType: json["media_type"],
      genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
      popularity: json["popularity"]?.toDouble(),
      releaseDate: json["release_date"] == null ? null : DateTime.tryParse(json["release_date"]),
      video: json["video"],
      voteAverage: json["vote_average"]?.toDouble(),
      voteCount: json["vote_count"],
      name: json["name"],
      originalName: json["original_name"],
      firstAirDate: json["first_air_date"] == null ? null : DateTime.tryParse(json["first_air_date"]),
      originCountry: json["origin_country"] == null ? [] : List<String>.from(json["origin_country"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "id": id,
    "title": title,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "poster_path": posterPath,
    "media_type": mediaType,
    "genre_ids": genreIds.map((x) => x).toList(),
    "popularity": popularity,
    "release_date": releaseDate?.toIso8601String().split('T')[0],
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
    "name": name,
    "original_name": originalName,
    "first_air_date": firstAirDate?.toIso8601String().split('T')[0],
    "origin_country": originCountry.map((x) => x).toList(),
  };

  @override
  String toString(){
    return "KnownFor(id: $id, title: $title, name: $name)";
  }
}