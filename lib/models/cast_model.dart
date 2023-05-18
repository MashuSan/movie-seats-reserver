class CastModel {
  late int id;
  late List<dynamic> cast;
  late List<dynamic> crew;

  // Named Constructor
  CastModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['id'];
    cast = parsedJson['cast'];
    crew = parsedJson['crew'];
  }
}