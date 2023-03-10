part of models;

class Product {
  late final String id;
  late final String name;
  String? description;
  String? gender;
  String? clothCategory;
  String? coverPhoto;
  String? category;
  String? shareUrl;
  String? sizes;
  String? color;
  String? status;
  double? price;
  double? discountPrice;
  bool? imp;
  bool? stock;
  String? createdAt;

  Product({
    required this.id,
    required this.name,
    this.description,
    this.coverPhoto,
    this.shareUrl,
    this.status,
    this.createdAt,
    this.gender,
    this.sizes,
    this.color,
    this.clothCategory,
    this.category,
    this.price,
    this.discountPrice,
    this.imp,
    this.stock,
  });

  Product.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    shareUrl = jsonData[ApiKeys.shareUrl] != null
        ? jsonData[ApiKeys.shareUrl].toString()
        : "";
    status = jsonData[ApiKeys.status] ?? "ACTIVE";
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    gender = jsonData[ApiKeys.gender] != null
        ? jsonData[ApiKeys.gender].toString()
        : "";
    sizes = jsonData[ApiKeys.sizes] != null
        ? jsonData[ApiKeys.sizes].toString()
        : "";
    color = jsonData[ApiKeys.color] != null
        ? jsonData[ApiKeys.color].toString()
        : "";
    clothCategory = jsonData[ApiKeys.clothCategory] != null
        ? jsonData[ApiKeys.clothCategory].toString()
        : "";
    category = jsonData[ApiKeys.category] != null
        ? jsonData[ApiKeys.category].toString()
        : "";
    price = jsonData[ApiKeys.price] != null
        ? double.parse(jsonData[ApiKeys.price].toString())
        : 0;
    discountPrice = jsonData[ApiKeys.discountPrice] != null
        ? double.parse(jsonData[ApiKeys.discountPrice].toString())
        : 0;
    imp = jsonData[ApiKeys.imp] != null
        ? jsonData[ApiKeys.imp] == 0
            ? false
            : true
        : false;
    stock = jsonData[ApiKeys.stock] != null
        ? jsonData[ApiKeys.stock] == 0
            ? false
            : true
        : false;
  }
}
