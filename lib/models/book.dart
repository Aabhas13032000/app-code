part of models;

class Book {
  late final String id;
  late final String title;
  late final String description;
  late final String author;
  late final String coverPhoto;
  late final String shareUrl;
  late final int status;
  late final int downloads;
  late final bool imp;
  late final double discountPrice;
  late final double price;
  late final String createdAt;
  late final String pdf;
  int? subscribedDays;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.coverPhoto,
    required this.shareUrl,
    required this.status,
    required this.downloads,
    required this.createdAt,
    required this.price,
    required this.discountPrice,
    required this.pdf,
    required this.imp,
  });

  Book.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    title = jsonData[ApiKeys.title] != null
        ? jsonData[ApiKeys.title].toString()
        : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    author = jsonData[ApiKeys.author] != null
        ? jsonData[ApiKeys.author].toString()
        : "";
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    shareUrl = jsonData[ApiKeys.shareUrl] != null
        ? jsonData[ApiKeys.shareUrl].toString()
        : "";
    pdf = jsonData[ApiKeys.pdf] != null ? jsonData[ApiKeys.pdf].toString() : "";
    status = jsonData[ApiKeys.status] ?? 0;
    imp = jsonData[ApiKeys.imp] != null
        ? jsonData[ApiKeys.imp] == 0
            ? false
            : true
        : false;
    discountPrice = jsonData[ApiKeys.discountPrice] != null
        ? double.parse(jsonData[ApiKeys.discountPrice].toString())
        : 0;
    price = jsonData[ApiKeys.price] != null
        ? double.parse(jsonData[ApiKeys.price].toString())
        : 0;
    downloads = jsonData[ApiKeys.downloads] ?? 0;
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    subscribedDays = jsonData[ApiKeys.subscribedDays] ?? 0;
  }
}
