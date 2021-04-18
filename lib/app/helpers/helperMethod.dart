import 'package:connectivity/connectivity.dart';
import 'package:flutter_ub/app/extension/sec.dart';
import 'package:flutter_ub/app/helpers/requestHelper.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:geolocator/geolocator.dart';

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
}
