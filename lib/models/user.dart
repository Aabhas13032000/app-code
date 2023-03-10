part of models;

class Users {
  late final String id;
  late final String name;
  late final String email;
  late final String gender;
  late final int age;
  late final double weight;
  late final double targetWeight;
  late final bool loggedIn;
  late final String deviceId;
  late final String profileImage;
  late final String phoneNumber;
  late final double height;
  late final String device;
  late final String status;
  late final bool isOtpVerified;
  late final String createdAt;
  late final String countryCode;
  String? medicalConditions;
  String? foodAllergies;
  String? goal;

  Users({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.targetWeight,
    required this.loggedIn,
    required this.deviceId,
    required this.profileImage,
    required this.phoneNumber,
    required this.height,
    required this.device,
    required this.status,
    required this.isOtpVerified,
    required this.createdAt,
    required this.countryCode,
    required this.medicalConditions,
    required this.foodAllergies,
    required this.goal,
  });

  Users.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id].toString();
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    email = jsonData[ApiKeys.email] != null
        ? jsonData[ApiKeys.email].toString()
        : "";
    gender = jsonData[ApiKeys.gender] != null
        ? jsonData[ApiKeys.gender].toString()
        : "";
    age = int.parse(jsonData[ApiKeys.age].toString()) ?? 0;
    weight = jsonData[ApiKeys.weight] != null
        ? double.parse(jsonData[ApiKeys.weight].toString())
        : 0;
    targetWeight = jsonData[ApiKeys.targetWeight] != null
        ? double.parse(jsonData[ApiKeys.targetWeight].toString())
        : 0;
    loggedIn = jsonData[ApiKeys.loggedIn] != null
        ? jsonData[ApiKeys.loggedIn] == 0
            ? false
            : true
        : false;
    deviceId = jsonData[ApiKeys.deviceId] != null
        ? jsonData[ApiKeys.deviceId].toString()
        : "";
    device = jsonData[ApiKeys.device] != null
        ? jsonData[ApiKeys.device].toString()
        : "";
    profileImage = jsonData[ApiKeys.profileImage] != null
        ? jsonData[ApiKeys.profileImage].toString()
        : "";
    phoneNumber = jsonData[ApiKeys.phoneNumber] != null
        ? jsonData[ApiKeys.phoneNumber].toString()
        : "";
    status = jsonData[ApiKeys.status] != null
        ? jsonData[ApiKeys.status].toString()
        : "";
    height = jsonData[ApiKeys.height] != null
        ? double.parse(jsonData[ApiKeys.height].toString())
        : 0;
    isOtpVerified = jsonData[ApiKeys.isOtpVerified] != null
        ? jsonData[ApiKeys.isOtpVerified] == 0
            ? false
            : true
        : false;
    createdAt = jsonData[ApiKeys.createdAt] ?? "";
    countryCode = jsonData[ApiKeys.countryCode] != null
        ? jsonData[ApiKeys.countryCode].toString()
        : "";
    medicalConditions = jsonData[ApiKeys.medicalConditions] != null
        ? jsonData[ApiKeys.medicalConditions].toString()
        : "";
    foodAllergies = jsonData[ApiKeys.foodAllergies] != null
        ? jsonData[ApiKeys.foodAllergies].toString()
        : "";
    goal =
        jsonData[ApiKeys.goal] != null ? jsonData[ApiKeys.goal].toString() : "";
  }
}
