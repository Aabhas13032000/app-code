part of models;

class Program {
  late final String id;
  late final String title;
  late final String description;
  String? shortDesc;
  String? tag;
  late final String coverPhoto;
  String? category;
  late final String shareUrl;
  late final int status;
  late final int views;
  double? price;
  bool? imp;
  late final String createdAt;
  bool? addressIncluded;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhoto,
    required this.shareUrl,
    required this.status,
    required this.views,
    required this.createdAt,
    this.shortDesc,
    this.tag,
    this.category,
    this.price,
    this.imp,
    this.addressIncluded,
  });

  Program.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    title = jsonData[ApiKeys.title] != null
        ? jsonData[ApiKeys.title].toString()
        : "";
    description = jsonData[ApiKeys.description] != null
        ? jsonData[ApiKeys.description].toString()
        : "";
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    shareUrl = jsonData[ApiKeys.shareUrl] != null
        ? jsonData[ApiKeys.shareUrl].toString()
        : "";
    status = jsonData[ApiKeys.status] ?? 0;
    views = jsonData[ApiKeys.views] ?? 0;
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    shortDesc = jsonData[ApiKeys.shortDesc] != null
        ? jsonData[ApiKeys.shortDesc].toString()
        : "";
    tag = jsonData[ApiKeys.tag] != null ? jsonData[ApiKeys.tag].toString() : "";
    category = jsonData[ApiKeys.category] != null
        ? jsonData[ApiKeys.category].toString()
        : "";
    price = jsonData[ApiKeys.price] != null
        ? double.parse(jsonData[ApiKeys.price].toString())
        : 0;
    imp = jsonData[ApiKeys.imp] != null
        ? jsonData[ApiKeys.imp] == 0
            ? false
            : true
        : false;
    addressIncluded = jsonData[ApiKeys.addressIncluded] != null
        ? jsonData[ApiKeys.addressIncluded] == 0
            ? false
            : true
        : false;
  }
}
