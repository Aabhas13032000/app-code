part of models;

class Orders {
  String? address;
  String? couponId;
  String? coverPhoto;
  String? datePurchased;
  String? details;
  String? fullName;
  String? id;
  String? itemCategory;
  String? itemId;
  String? orderId;
  String? paidPrice;
  String? paymentMethod;
  String? paymentStatus;
  String? phoneNumber;
  String? productName;
  String? status;
  String? userId;
  int? quantity;

  Orders();

  Orders.fromJson(Map<String, dynamic> jsonData) {
    address = jsonData[ApiKeys.address] != null
        ? jsonData[ApiKeys.address].toString()
        : "";
    couponId = jsonData[ApiKeys.couponId] != null
        ? jsonData[ApiKeys.couponId].toString()
        : "";
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    datePurchased = jsonData[ApiKeys.datePurchased] != null
        ? jsonData[ApiKeys.datePurchased].toString()
        : "";
    details = jsonData[ApiKeys.details] != null
        ? jsonData[ApiKeys.details].toString()
        : "";
    fullName = jsonData[ApiKeys.fullName] != null
        ? jsonData[ApiKeys.fullName].toString()
        : "";
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    itemCategory = jsonData[ApiKeys.itemCategory] != null
        ? jsonData[ApiKeys.itemCategory].toString()
        : "";
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : "";
    orderId = jsonData[ApiKeys.orderId] != null
        ? jsonData[ApiKeys.orderId].toString()
        : "";
    paidPrice = jsonData[ApiKeys.paidPrice] != null
        ? jsonData[ApiKeys.paidPrice].toString()
        : "";
    paymentMethod = jsonData[ApiKeys.paymentMethod] != null
        ? jsonData[ApiKeys.paymentMethod].toString()
        : "";
    paymentStatus = jsonData[ApiKeys.paymentStatus] != null
        ? jsonData[ApiKeys.paymentStatus].toString()
        : "";
    phoneNumber = jsonData[ApiKeys.phoneNumber] != null
        ? jsonData[ApiKeys.phoneNumber].toString()
        : "";
    productName = jsonData[ApiKeys.productName] != null
        ? jsonData[ApiKeys.productName].toString()
        : "";
    status = jsonData[ApiKeys.status] != null
        ? jsonData[ApiKeys.status].toString()
        : "";
    userId = jsonData[ApiKeys.userId] != null
        ? jsonData[ApiKeys.userId].toString()
        : "";
    quantity = jsonData[ApiKeys.quantity] != null
        ? int.parse(jsonData[ApiKeys.quantity].toString())
        : 0;
  }
}
