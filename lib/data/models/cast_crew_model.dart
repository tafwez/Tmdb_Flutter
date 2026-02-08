class CastCrewModel {
  CastCrewModel({
    required this.id,
    required this.cast,
    required this.crew,
  });

  final int? id;
  final List<Cast> cast;
  final List<Cast> crew;

  factory CastCrewModel.fromJson(Map<String, dynamic> json){
    return CastCrewModel(
      id: json["id"],
      cast: json["cast"] == null ? [] : List<Cast>.from(json["cast"]!.map((x) => Cast.fromJson(x))),
      crew: json["crew"] == null ? [] : List<Cast>.from(json["crew"]!.map((x) => Cast.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cast": cast.map((x) => x?.toJson()).toList(),
    "crew": crew.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$id, $cast, $crew, ";
  }
}

class Cast {
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
    required this.department,
    required this.job,
  });

  final bool? adult;
  final int? gender;
  final int? id;
  final String? knownForDepartment;
  final String? name;
  final String? originalName;
  final double? popularity;
  final String? profilePath;
  final int? castId;
  final String? character;
  final String? creditId;
  final int? order;
  final String? department;
  final String? job;

  factory Cast.fromJson(Map<String, dynamic> json){
    return Cast(
      adult: json["adult"],
      gender: json["gender"],
      id: json["id"],
      knownForDepartment: json["known_for_department"],
      name: json["name"],
      originalName: json["original_name"],
      popularity: json["popularity"],
      profilePath: json["profile_path"],
      castId: json["cast_id"],
      character: json["character"],
      creditId: json["credit_id"],
      order: json["order"],
      department: json["department"],
      job: json["job"],
    );
  }

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "gender": gender,
    "id": id,
    "known_for_department": knownForDepartment,
    "name": name,
    "original_name": originalName,
    "popularity": popularity,
    "profile_path": profilePath,
    "cast_id": castId,
    "character": character,
    "credit_id": creditId,
    "order": order,
    "department": department,
    "job": job,
  };

  @override
  String toString(){
    return "$adult, $gender, $id, $knownForDepartment, $name, $originalName, $popularity, $profilePath, $castId, $character, $creditId, $order, $department, $job, ";
  }
}
