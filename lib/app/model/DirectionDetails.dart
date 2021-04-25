class DirectionDetails {
  String distanceText;
  String durationText;
  int durationValue;
  int distanceValue;
  String encodedPoints;

  DirectionDetails({
    this.distanceText,
    this.durationText,
    this.durationValue,
    this.distanceValue,
    this.encodedPoints,
  });

  DirectionDetails.fromJson(Map<String, dynamic> json) {
    durationText = json["routes"][0]["legs"][0]["duration"]["text"];
    durationValue = json["routes"][0]["legs"][0]["duration"]["value"];
    distanceText = json["routes"][0]["legs"][0]["distance"]["text"];
    distanceValue = json["routes"][0]["legs"][0]["distance"]["value"];
    encodedPoints = json["routes"][0]["overview_polyline"]["points"];
  }
}
