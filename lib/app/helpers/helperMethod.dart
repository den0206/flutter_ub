import 'package:connectivity/connectivity.dart';
import 'package:flutter_ub/app/extension/sec.dart';
import 'package:flutter_ub/app/helpers/requestHelper.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:flutter_ub/app/model/DirectionDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelperMethod {
  static Future<Address> findCordingAddress(Position position) async {
    String placeAddress = "";
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      return null;
    }

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${SDKMapKey.iosKey}";

    var response = await RequestHelper.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      Address address = Address();
      address.longtude = position.longitude;
      address.latitude = position.latitude;
      address.placeName = placeAddress;

      return address;
    }

    return null;
  }

  static Future<DirectionDetails> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=${SDKMapKey.iosKey}";

    print(url);

    var response = await RequestHelper.getRequest(url);

    if (response == "fail") {
      print("Fail");
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.encodedPoints =
        response["routes"][0]["overview_polyline"]["points"];

    return directionDetails;
  }
}
