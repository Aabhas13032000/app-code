part of models;

class Food {
  String? id;
  String? name;
  double? calories;
  double? carbs;
  double? fats;
  double? fiber;
  double? protein;
  double? quantity;
  String? coverPhoto;
  String? description;
  String? unit;
  int? status;

  Food();

  Food.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
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
    quantity = jsonData[ApiKeys.quantity] != null
        ? double.parse(jsonData[ApiKeys.quantity].toString())
        : 0;
    unit = jsonData[ApiKeys.units] != null
        ? jsonData[ApiKeys.units].toString()
        : '';
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    status = jsonData[ApiKeys.status] ?? 0;
  }
}
