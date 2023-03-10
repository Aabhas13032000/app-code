part of models;

class Trainer {
  late final String id;
  late final String name;
  late final String about;
  late final String expertise;
  late final String qualification;
  late final String vision;
  late final String profileImage;
  late final String status;
  bool? imp;
  late final String createdAt;

  Trainer({
    required this.id,
    required this.name,
    required this.about,
    required this.expertise,
    required this.qualification,
    required this.vision,
    required this.profileImage,
    required this.status,
    required this.createdAt,
    this.imp,
  });

  Trainer.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    about = jsonData[ApiKeys.about] != null
        ? jsonData[ApiKeys.about].toString()
        : "";
    expertise = jsonData[ApiKeys.expertise] != null
        ? jsonData[ApiKeys.expertise].toString()
        : "";
    qualification = jsonData[ApiKeys.qualification] != null
        ? jsonData[ApiKeys.qualification].toString()
        : "";
    vision = jsonData[ApiKeys.vision] != null
        ? jsonData[ApiKeys.vision].toString()
        : "";
    profileImage = jsonData[ApiKeys.profileImage] != null
        ? jsonData[ApiKeys.profileImage].toString()
        : "";
    status = jsonData[ApiKeys.status] != null
        ? jsonData[ApiKeys.status].toString()
        : "";
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    imp = jsonData[ApiKeys.imp] != null
        ? jsonData[ApiKeys.imp] == 0
            ? false
            : true
        : false;
  }
}
