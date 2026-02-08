
import 'package:intl/intl.dart';

class MovieDetailModel {
  MovieDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.belongsToCollection,
    required this.budget,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.releaseDate,
    required this.revenue,
    required this.runtime,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool? adult;
  final String? backdropPath;
  final dynamic belongsToCollection;
  final int? budget;
  final List<Genre> genres;
  final String? homepage;
  final int? id;
  final String? imdbId;
  final String? originalLanguage;
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final DateTime? releaseDate;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage> spokenLanguages;
  final String? status;
  final String? tagline;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  factory MovieDetailModel.fromJson(Map<String, dynamic> json){
    return MovieDetailModel(
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      belongsToCollection: json["belongs_to_collection"],
      budget: json["budget"],
      genres: json["genres"] == null ? [] : List<Genre>.from(json["genres"]!.map((x) => Genre.fromJson(x))),
      homepage: json["homepage"],
      id: json["id"],
      imdbId: json["imdb_id"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      productionCompanies: json["production_companies"] == null ? [] : List<ProductionCompany>.from(json["production_companies"]!.map((x) => ProductionCompany.fromJson(x))),
      productionCountries: json["production_countries"] == null ? [] : List<ProductionCountry>.from(json["production_countries"]!.map((x) => ProductionCountry.fromJson(x))),
      releaseDate: DateTime.tryParse(json["release_date"] ?? ""),
      revenue: json["revenue"],
      runtime: json["runtime"],
      spokenLanguages: json["spoken_languages"] == null ? [] : List<SpokenLanguage>.from(json["spoken_languages"]!.map((x) => SpokenLanguage.fromJson(x))),
      status: json["status"],
      tagline: json["tagline"],
      title: json["title"],
      video: json["video"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "belongs_to_collection": belongsToCollection,
    "budget": budget,
    "genres": genres.map((x) => x?.toJson()).toList(),
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "original_language": originalLanguage,
    "original_title": originalTitle,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": productionCompanies.map((x) => x?.toJson()).toList(),
    "production_countries": productionCountries.map((x) => x?.toJson()).toList(),
    "release_date": DateFormat('yyyy-MM-dd').format(releaseDate ?? DateTime.now()),
    "revenue": revenue,
    "runtime": runtime,
    "spoken_languages": spokenLanguages.map((x) => x?.toJson()).toList(),
    "status": status,
    "tagline": tagline,
    "title": title,
    "video": video,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  @override
  String toString(){
    return "$adult, $backdropPath, $belongsToCollection, $budget, $genres, $homepage, $id, $imdbId, $originalLanguage, $originalTitle, $overview, $popularity, $posterPath, $productionCompanies, $productionCountries, $releaseDate, $revenue, $runtime, $spokenLanguages, $status, $tagline, $title, $video, $voteAverage, $voteCount, ";
  }
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  final int? id;
  final String? name;

  factory Genre.fromJson(Map<String, dynamic> json){
    return Genre(
      id: json["id"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  @override
  String toString(){
    return "$id, $name, ";
  }
}

class ProductionCompany {
  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  final int? id;
  final String? logoPath;
  final String? name;
  final String? originCountry;

  factory ProductionCompany.fromJson(Map<String, dynamic> json){
    return ProductionCompany(
      id: json["id"],
      logoPath: json["logo_path"],
      name: json["name"],
      originCountry: json["origin_country"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo_path": logoPath,
    "name": name,
    "origin_country": originCountry,
  };

  @override
  String toString(){
    return "$id, $logoPath, $name, $originCountry, ";
  }
}

class ProductionCountry {
  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  final String? iso31661;
  final String? name;

  factory ProductionCountry.fromJson(Map<String, dynamic> json){
    return ProductionCountry(
      iso31661: json["iso_3166_1"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "iso_3166_1": iso31661,
    "name": name,
  };

  @override
  String toString(){
    return "$iso31661, $name, ";
  }
}

class SpokenLanguage {
  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  final String? englishName;
  final String? iso6391;
  final String? name;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json){
    return SpokenLanguage(
      englishName: json["english_name"],
      iso6391: json["iso_639_1"],
      name: json["name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "english_name": englishName,
    "iso_639_1": iso6391,
    "name": name,
  };

  @override
  String toString(){
    return "$englishName, $iso6391, $name, ";
  }
}
