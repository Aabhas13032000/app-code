part of models;

class Testimonial {
  late final String id;
  late final String name;
  late final String message;
  late final String profileImage;
  late final String tagLine;
  late final int status;
  late final int imp;
  late final String createdAt;

  Testimonial({
    required this.id,
    required this.name,
    required this.message,
    required this.profileImage,
    required this.tagLine,
    required this.status,
    required this.imp,
    required this.createdAt,
  });

  Testimonial.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    message = jsonData[ApiKeys.message] != null
        ? jsonData[ApiKeys.message].toString()
        : "";
    profileImage = jsonData[ApiKeys.profileImage] != null
        ? jsonData[ApiKeys.profileImage].toString()
        : "";
    tagLine = jsonData[ApiKeys.tagLine] != null
        ? jsonData[ApiKeys.tagLine].toString()
        : "";
    status = jsonData[ApiKeys.status] ?? 0;
    imp = jsonData[ApiKeys.imp] ?? 0;
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
  }
}
