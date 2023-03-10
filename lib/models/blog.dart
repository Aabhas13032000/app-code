part of models;

class Blogs {
  late final String id;
  late final String title;
  late final String description;
  late final String coverPhoto;
  late final String shareUrl;
  late final int status;
  late final int views;
  late final int totalLikes;
  late final String createdAt;
  late final bool isLiked;

  Blogs({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhoto,
    required this.shareUrl,
    required this.status,
    required this.views,
    required this.totalLikes,
    required this.createdAt,
    required this.isLiked,
  });

  Blogs.fromJson(Map<String, dynamic> jsonData) {
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
    totalLikes = jsonData[ApiKeys.totalLikes] ?? 0;
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    isLiked = jsonData[ApiKeys.isLiked] != null
        ? jsonData[ApiKeys.isLiked] == 0
            ? false
            : true
        : false;
  }
}
