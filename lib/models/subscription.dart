part of models;

class Subscription {
  String? coverPhoto;
  String? dayId;
  int? daysLeft;
  String? itemId;
  String? programId;
  String? meetingUrl;
  int? sessionCount;
  double? price;
  String? sessionId;
  String? sessionType;
  String? subscriptionId;
  String? timeId;
  String? cartId;
  String? trainerId;
  String? id;
  String? title;
  String? trainerName;
  String? pdfPath;

  Subscription();

  Subscription.fromJson(Map<String, dynamic> jsonData) {
    daysLeft = jsonData[ApiKeys.daysLeft] != null
        ? int.parse(jsonData[ApiKeys.daysLeft].toString())
        : 0;
    sessionCount = jsonData[ApiKeys.sessionCount] != null
        ? int.parse(jsonData[ApiKeys.sessionCount].toString())
        : 0;
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    dayId = jsonData[ApiKeys.dayId] != null
        ? jsonData[ApiKeys.dayId].toString()
        : "";
    itemId = jsonData[ApiKeys.itemId] != null
        ? jsonData[ApiKeys.itemId].toString()
        : "";
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    cartId = jsonData[ApiKeys.cartId] != null
        ? jsonData[ApiKeys.cartId].toString()
        : "";
    programId = jsonData[ApiKeys.programId] != null
        ? jsonData[ApiKeys.programId].toString()
        : "";
    meetingUrl = jsonData[ApiKeys.meetingUrl] != null
        ? jsonData[ApiKeys.meetingUrl].toString()
        : "";
    sessionId = jsonData[ApiKeys.sessionId] != null
        ? jsonData[ApiKeys.sessionId].toString()
        : "";
    sessionType = jsonData[ApiKeys.sessionType] != null
        ? jsonData[ApiKeys.sessionType].toString()
        : "";
    subscriptionId = jsonData[ApiKeys.subscriptionId] != null
        ? jsonData[ApiKeys.subscriptionId].toString()
        : "";
    timeId = jsonData[ApiKeys.timeId] != null
        ? jsonData[ApiKeys.timeId].toString()
        : "";
    trainerId = jsonData[ApiKeys.trainerId] != null
        ? jsonData[ApiKeys.trainerId].toString()
        : "";
    title = jsonData[ApiKeys.title] != null
        ? jsonData[ApiKeys.title].toString()
        : "";
    trainerName = jsonData[ApiKeys.trainerName] != null
        ? jsonData[ApiKeys.trainerName].toString()
        : "";
    price = jsonData[ApiKeys.price] != null
        ? double.parse(jsonData[ApiKeys.price].toString())
        : 0;
    pdfPath = jsonData[ApiKeys.pdfPath] != null
        ? jsonData[ApiKeys.pdfPath].toString()
        : "";
  }
}
