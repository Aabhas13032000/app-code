part of models;

class UsersExercise {
  late final String id;
  late final String name;
  double? calories;
  double? weight;
  double? min;
  double? exerciseCalories;
  int? exercisePerset;
  int? exerciseSet;
  int? perset;
  int? sets;
  String? coverPhoto;
  String? createdAt;
  String? description;
  String? userId;
  String? exerciseId;
  String? cat;

  UsersExercise({
    required this.id,
    required this.name,
    this.calories,
    this.weight,
    this.min,
    this.exerciseCalories,
    this.exercisePerset,
    this.exerciseSet,
    this.sets,
    this.perset,
    this.coverPhoto,
    this.createdAt,
    this.description,
    this.userId,
    this.exerciseId,
    this.cat,
  });

  UsersExercise.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    userId = jsonData[ApiKeys.userId] != null
        ? jsonData[ApiKeys.userId].toString()
        : "";
    weight = jsonData[ApiKeys.weight] != null
        ? double.parse(jsonData[ApiKeys.weight].toString())
        : 0;
    min = jsonData[ApiKeys.min] != null
        ? double.parse(jsonData[ApiKeys.min].toString())
        : 0;
    exerciseId = jsonData[ApiKeys.exerciseId] != null
        ? jsonData[ApiKeys.exerciseId].toString()
        : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    calories = jsonData[ApiKeys.calories] != null
        ? double.parse(jsonData[ApiKeys.calories].toString())
        : 0;
    exercisePerset = jsonData[ApiKeys.exercisePerset] != null
        ? int.parse(jsonData[ApiKeys.exercisePerset].toString())
        : 0;
    exerciseSet = jsonData[ApiKeys.exerciseSet] != null
        ? int.parse(jsonData[ApiKeys.exerciseSet].toString())
        : 0;
    sets = jsonData[ApiKeys.sets] != null
        ? int.parse(jsonData[ApiKeys.sets].toString())
        : 0;
    perset = jsonData[ApiKeys.perset] != null
        ? int.parse(jsonData[ApiKeys.perset].toString())
        : 0;
    exerciseCalories = jsonData[ApiKeys.exerciseCalories] != null
        ? double.parse(jsonData[ApiKeys.exerciseCalories].toString())
        : 0;
    cat = jsonData[ApiKeys.cat] != null ? jsonData[ApiKeys.cat].toString() : '';
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
  }
}
