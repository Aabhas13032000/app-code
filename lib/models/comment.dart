part of models;

class Comment {
  late final String id;
  late final String userId;
  late final String category;
  late final String itemCategory;
  late final String itemId;
  late final String message;
  late final String name;
  late final String profileImage;
  late final String createdAt;

  Comment();

  Comment.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    userId = jsonData[ApiKeys.userId].toString();
    category = jsonData[ApiKeys.category] ?? "";
    itemCategory = jsonData[ApiKeys.itemCategory] ?? "";
    itemId = jsonData[ApiKeys.itemId].toString();
    message = jsonData[ApiKeys.message] != null
        ? jsonData[ApiKeys.message].toString()
        : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    profileImage = jsonData[ApiKeys.profileImage] != null
        ? jsonData[ApiKeys.profileImage].toString()
        : "";
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
  }
}
