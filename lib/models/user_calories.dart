part of models;

class UsersCalories {
  late final String id;
  late final String name;
  double? calories;
  double? carbs;
  double? fats;
  double? fiber;
  double? protein;
  double? foodCalories;
  double? foodQuantity;
  double? servings;
  String? coverPhoto;
  String? createdAt;
  String? description;
  String? foodId;
  String? foodUnit;
  String? unit;
  String? meal;
  String? userId;

  UsersCalories({
    required this.id,
    required this.name,
    this.calories,
    this.carbs,
    this.fats,
    this.fiber,
    this.protein,
    this.foodCalories,
    this.servings,
    this.foodQuantity,
    this.coverPhoto,
    this.createdAt,
    this.description,
    this.foodId,
    this.foodUnit,
    this.unit,
    this.meal,
    this.userId,
  });

  UsersCalories.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    userId = jsonData[ApiKeys.userId] != null
        ? jsonData[ApiKeys.userId].toString()
        : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    calories = jsonData[ApiKeys.calories] != null
        ? double.parse(jsonData[ApiKeys.calories].toString())
        : 0;
    carbs = jsonData[ApiKeys.carbs] != null
        ? double.parse(jsonData[ApiKeys.carbs].toString())
        : 0;
    fats = jsonData[ApiKeys.fats] != null
        ? double.parse(jsonData[ApiKeys.fats].toString())
        : 0;
    fiber = jsonData[ApiKeys.fiber] != null
        ? double.parse(jsonData[ApiKeys.fiber].toString())
        : 0;
    protein = jsonData[ApiKeys.protein] != null
        ? double.parse(jsonData[ApiKeys.protein].toString())
        : 0;
    foodCalories = jsonData[ApiKeys.foodCalories] != null
        ? double.parse(jsonData[ApiKeys.foodCalories].toString())
        : 0;
    servings = jsonData[ApiKeys.servings] != null
        ? double.parse(jsonData[ApiKeys.servings].toString())
        : 0;
    foodQuantity = jsonData[ApiKeys.foodQuantity] != null
        ? double.parse(jsonData[ApiKeys.foodQuantity].toString())
        : 0;
    foodId = jsonData[ApiKeys.foodId] != null
        ? jsonData[ApiKeys.foodId].toString()
        : '';
    foodUnit = jsonData[ApiKeys.foodUnit] != null
        ? jsonData[ApiKeys.foodUnit].toString()
        : '';
    unit =
        jsonData[ApiKeys.unit] != null ? jsonData[ApiKeys.unit].toString() : '';
    meal =
        jsonData[ApiKeys.meal] != null ? jsonData[ApiKeys.meal].toString() : '';
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
  }
}
