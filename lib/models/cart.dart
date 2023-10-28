part of models;

class Cart {
  String? id;
  String? cartId;
  String? name;
  String? coverPhoto;
  String? description;
  String? itemCategory;
  String? itemId;
  double? discountPrice;
  double? price;
  int? maximumQuantity;
  int? quantity;

  Cart({
    this.id,
    this.cartId,
    this.name,
    this.coverPhoto,
    this.description,
    this.discountPrice,
    this.price,
    this.itemCategory,
    this.itemId,
    this.maximumQuantity,
    this.quantity,
  });

  Cart.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    cartId = jsonData[ApiKeys.cartId].toString();
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    discountPrice = jsonData[ApiKeys.discountPrice] != null
        ? double.parse(jsonData[ApiKeys.discountPrice].toString())
        : 0;
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : jsonData[ApiKeys.id] != null
            ? jsonData[ApiKeys.id].toString()
            : "";
    itemCategory = jsonData[ApiKeys.itemCategory] != null
        ? jsonData[ApiKeys.itemCategory].toString()
        : jsonData[ApiKeys.category] != null
            ? jsonData[ApiKeys.category].toString()
            : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    price = jsonData[ApiKeys.price] != null
        ? double.parse(jsonData[ApiKeys.price].toString())
        : 0;
    maximumQuantity = jsonData[ApiKeys.maximumQuantity] != null
        ? int.parse(jsonData[ApiKeys.maximumQuantity].toString())
        : 0;
    quantity = jsonData[ApiKeys.quantity] != null
        ? int.parse(jsonData[ApiKeys.quantity].toString())
        : 0;
  }
}
