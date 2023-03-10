part of models;

class StateCity {
  String? id;
  String? name;
  String? stateId;
  String? stateName;
  String? countryId;

  StateCity();

  StateCity.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData[ApiKeys.id] != null ? jsonData[ApiKeys.id].toString() : "";
    name =
        jsonData[ApiKeys.name] != null ? jsonData[ApiKeys.name].toString() : "";
    stateId = jsonData[ApiKeys.stateId] != null
        ? jsonData[ApiKeys.stateId].toString()
        : "";
    stateName = jsonData[ApiKeys.stateName] != null
        ? jsonData[ApiKeys.stateName].toString()
        : "";
    countryId = jsonData[ApiKeys.countryId] != null
        ? jsonData[ApiKeys.countryId].toString()
        : "";
  }
}
