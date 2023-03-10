part of models;

class Exercise {
  String? id;
  String? name;
  double? calories;
  int? perset;
  int? sets;
  String? coverPhoto;
  String? description;
  String? cat;
  int? status;
  double? weight;

  Exercise();

  Exercise.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    calories = jsonData[ApiKeys.calories] != null
        ? double.parse(jsonData[ApiKeys.calories].toString())
        : 0;
    weight = jsonData[ApiKeys.weight] != null
        ? double.parse(jsonData[ApiKeys.weight].toString())
        : 0;
    sets = jsonData[ApiKeys.sets] != null
        ? int.parse(jsonData[ApiKeys.sets].toString())
        : 0;
    perset = jsonData[ApiKeys.perset] != null
        ? int.parse(jsonData[ApiKeys.perset].toString())
        : 0;
    cat = jsonData[ApiKeys.cat] != null ? jsonData[ApiKeys.cat].toString() : '';
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    status = jsonData[ApiKeys.status] ?? 0;
  }
}
