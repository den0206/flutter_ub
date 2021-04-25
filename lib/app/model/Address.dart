class Address {
  Address({
    this.placeName,
    this.latitude,
    this.longtude,
    this.placeId,
    this.placeformattedAddress,
  });

  String placeName;
  double latitude;
  double longtude;
  String placeId;
  String placeformattedAddress;

  Address.fromJson(Map<String, dynamic> json, String placeId) {
    placeId = placeId;
    placeName = json["result"]["name"];
    latitude = json["result"]["geometry"]["location"]["lat"];
    longtude = json["result"]["geometry"]["location"]["lng"];
  }
}
