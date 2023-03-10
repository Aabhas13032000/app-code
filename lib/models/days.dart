part of models;

class Day {
  String? dayId;

  Day({
    this.dayId,
  });

  Day.fromJson(Map<String, dynamic> jsonData) {
    dayId = jsonData[ApiKeys.dayId].toString();
  }
}

class Session {
  String? sessionId;

  Session({
    this.sessionId,
  });

  Session.fromJson(Map<String, dynamic> jsonData) {
    sessionId = jsonData[ApiKeys.sessionId].toString();
  }
}

class Timing {
  String? timeId;

  Timing({
    this.timeId,
  });

  Timing.fromJson(Map<String, dynamic> jsonData) {
    timeId = jsonData[ApiKeys.timeId].toString();
  }
}
