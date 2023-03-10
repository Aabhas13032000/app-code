part of models;

class CurectCategories {
  String? id;
  String? name;
  bool? imp;
  bool? homeImp;
  String? webSlider;
  String? mobileSlider;
  String? coverPhoto;
  String? clothCategory;

  CurectCategories({
    this.id,
    this.name,
    this.coverPhoto,
    this.imp,
    this.homeImp,
    this.webSlider,
    this.mobileSlider,
    this.clothCategory,
  });

  CurectCategories.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    imp = jsonData[ApiKeys.imp] == 0 ? false : true;
    homeImp = jsonData[ApiKeys.homeImp] == 0 ? false : true;
    coverPhoto = jsonData[ApiKeys.coverPhoto] != null
        ? jsonData[ApiKeys.coverPhoto].toString()
        : "";
    webSlider = jsonData[ApiKeys.webSlider] != null
        ? jsonData[ApiKeys.webSlider].toString()
        : "";
    mobileSlider = jsonData[ApiKeys.mobileSlider] != null
        ? jsonData[ApiKeys.mobileSlider].toString()
        : "";
    clothCategory = jsonData[ApiKeys.clothCategory] != null
        ? jsonData[ApiKeys.clothCategory].toString()
        : "";
  }
}
