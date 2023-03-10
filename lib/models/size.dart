part of models;

class Sizes {
  String? id;
  String? itemId;
  int? quantity;
  String? size;

  Sizes({
    this.id,
    this.itemId,
    this.quantity,
    this.size,
  });

  Sizes.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : "";
    quantity = jsonData[ApiKeys.quantity] != null
        ? int.parse(jsonData[ApiKeys.quantity].toString())
        : 0;
    size =
        jsonData[ApiKeys.size] != null ? jsonData[ApiKeys.size].toString() : "";
  }
}
