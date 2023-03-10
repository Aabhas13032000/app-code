part of models;

class Address {
  String? id;
  String? area;
  String? city;
  String? country;
  String? category;
  bool? defaultAddress;
  String? flatNo;
  String? fullName;
  String? landmark;
  String? phoneNumber;
  String? pincode;
  String? state;
  String? userId;

  Address();

  Address.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    area =
        jsonData[ApiKeys.area] != null ? jsonData[ApiKeys.area].toString() : "";
    city =
        jsonData[ApiKeys.city] != null ? jsonData[ApiKeys.city].toString() : "";
    country = jsonData[ApiKeys.country] != null
        ? jsonData[ApiKeys.country].toString()
        : "";
    category = jsonData[ApiKeys.category] != null
        ? jsonData[ApiKeys.category].toString()
        : "";
    flatNo = jsonData[ApiKeys.flatNo] != null
        ? jsonData[ApiKeys.flatNo].toString()
        : "";
    fullName = jsonData[ApiKeys.fullName] != null
        ? jsonData[ApiKeys.fullName].toString()
        : "";
    landmark = jsonData[ApiKeys.landmark] != null
        ? jsonData[ApiKeys.landmark].toString()
        : "";
    phoneNumber = jsonData[ApiKeys.phoneNumber] != null
        ? jsonData[ApiKeys.phoneNumber].toString()
        : "";
    pincode = jsonData[ApiKeys.pincode] != null
        ? jsonData[ApiKeys.pincode].toString()
        : "";
    userId = jsonData[ApiKeys.userId] != null
        ? jsonData[ApiKeys.userId].toString()
        : "";
    state = jsonData[ApiKeys.state] != null
        ? jsonData[ApiKeys.state].toString()
        : "";
    defaultAddress = jsonData[ApiKeys.defaultAddress] != null
        ? jsonData[ApiKeys.defaultAddress] == 0
            ? false
            : true
        : false;
  }
}
