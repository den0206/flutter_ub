import 'package:flutter/material.dart';
import 'package:flutter_ub/app/helpers/helperMethod.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainPageModel extends ChangeNotifier {
  MainPageModel({
    @required this.sheetHeight,
  });

  final double sheetHeight;
  GoogleMapController mapController;
  double mapBottomPadding = 0;

  /// initial position
  final CameraPosition kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  var geoLocator = Geolocator();
  Position currentPosition;

  void setPositionLocator({Function(Address) onSuccess}) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    Address address = await HelperMethod.findCordingAddress(position);

    if (address != null) {
      onSuccess(address);
    }
  }

  changePadding() {
    mapBottomPadding = sheetHeight - 30;
    notifyListeners();
  }
}
