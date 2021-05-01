import 'package:cloud_firestore/cloud_firestore.dart';

class NearByDriver {
  NearByDriver({
    this.geoHash,
    this.latitude,
    this.longitude,
  });
  String geoHash;
  double latitude;
  double longitude;

  NearByDriver.fromDocument(DocumentSnapshot document) {
    this.geoHash = document.data()["postion"]["geohash"];

    GeoPoint point = document.data()["postion"]["geopoint"];
    this.latitude = point.latitude;
    this.longitude = point.longitude;
  }
}
