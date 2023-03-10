part of models;

class Cart {
  String? id;
  String? cartId;
  String? programId;
  String? title;
  String? name;
  String? sessionId;
  String? dayId;
  String? trainerId;
  String? timeId;
  String? coverPhoto;
  String? description;
  String? meetingUrl;
  String? sessionType;
  String? trainerName;
  String? itemCategory;
  String? itemId;
  double? discountPrice;
  double? price;
  int? maximumQuantity;
  int? quantity;

  Cart({
    this.id,
    this.cartId,
    this.programId,
    this.title,
    this.name,
    this.sessionId,
    this.coverPhoto,
    this.description,
    this.discountPrice,
    this.trainerId,
    this.dayId,
    this.timeId,
    this.meetingUrl,
    this.sessionType,
    this.trainerName,
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
    programId = jsonData[ApiKeys.programId] != null
        ? jsonData[ApiKeys.programId].toString()
        : "";
    trainerId = jsonData[ApiKeys.trainerId] != null
        ? jsonData[ApiKeys.trainerId].toString()
        : "";
    trainerName = jsonData[ApiKeys.trainerName] != null
        ? jsonData[ApiKeys.trainerName].toString()
        : "";
    sessionId = jsonData[ApiKeys.sessionId] != null
        ? jsonData[ApiKeys.sessionId].toString()
        : "";
    title = jsonData[ApiKeys.title] != null
        ? jsonData[ApiKeys.title].toString()
        : "";
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : jsonData[ApiKeys.id] != null
            ? jsonData[ApiKeys.id].toString()
            : "";
    itemId = jsonData[ApiKeys.itemCategory] != null
        ? jsonData[ApiKeys.itemCategory].toString()
        : jsonData[ApiKeys.category] != null
            ? jsonData[ApiKeys.category].toString()
            : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    dayId = jsonData[ApiKeys.dayId].toString();
    timeId = jsonData[ApiKeys.timeId].toString();
    meetingUrl = jsonData[ApiKeys.meetingUrl] != null
        ? jsonData[ApiKeys.meetingUrl].toString()
        : "";
    sessionType = jsonData[ApiKeys.sessionType] != null
        ? jsonData[ApiKeys.sessionType].toString()
        : "";
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
