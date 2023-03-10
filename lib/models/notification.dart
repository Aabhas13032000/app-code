part of models;

class Notifications {
  String? itemId;
  String? id;
  String? message;
  String? itemCategory;
  String? type;
  String? userId;
  String? createdAt;

  Notifications();

  Notifications.fromJson(Map<String, dynamic> jsonData) {
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : "";
    message = jsonData[ApiKeys.message] != null
        ? jsonData[ApiKeys.message].toString()
        : "";
    itemCategory = jsonData[ApiKeys.itemCategory] != null
        ? jsonData[ApiKeys.itemCategory].toString()
        : "";
    type =
        jsonData[ApiKeys.type] != null ? jsonData[ApiKeys.type].toString() : "";
    userId = jsonData[ApiKeys.userId] != null
        ? jsonData[ApiKeys.userId].toString()
        : "";
    createdAt = jsonData[ApiKeys.createdAt] != null
        ? jsonData[ApiKeys.createdAt].toString()
        : "";
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
  }
}
