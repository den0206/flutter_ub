import 'dart:math';

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
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails.fromJson(response);

    return directionDetails;
  }

  static int estimateFares(DirectionDetails details) {
    double baseFare = 3;
    double distanceFare = (details.distanceValue / 1000) * 0.3;
    double timeFare = (details.distanceValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

  static double generateRandomumber(int max) {
    var generator = Random();

    int ranInt = generator.nextInt(max);

    return ranInt.toDouble();
  }
}
