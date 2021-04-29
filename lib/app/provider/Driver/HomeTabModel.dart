import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTabModel extends ChangeNotifier {
  GoogleMapController mapController;

  final geo = Geoflutterfire();

  var geoLocator = Geolocator();

  Position currentPosition;
  bool isOnline = false;

  GeoFireCollectionRef geoRef = Geoflutterfire()
      .collection(collectionRef: firebaseRef(FirebaseRef.location));

  GeoFirePoint myLocation;

  @override
  void dispose() {
    print("Dispose");
    homeTabPositionStrem.cancel();
    super.dispose();
  }

  void setPositionLocatoe() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
  }

  void goOnline() {
    myLocation = geo.point(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );

    Map<String, dynamic> value = {
      "postion": myLocation.data,
    };

    geoRef.setDoc(currentUser.id, value);

    isOnline = true;
    notifyListeners();
  }

  void getLovationUpdate() {
    homeTabPositionStrem = Geolocator.getPositionStream(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 50)
        .listen((Position position) {
      double distance = Geolocator.distanceBetween(currentPosition.latitude,
          currentPosition.longitude, position.latitude, position.longitude);

      if (distance > 100 && isOnline) {
        currentPosition = position;
        print("Update");
        geoRef.setPoint(currentUser.id, "postion", currentPosition.latitude,
            currentPosition.longitude);
      }

      LatLng pos = LatLng(position.latitude, position.longitude);
      CameraPosition cp = CameraPosition(target: pos, zoom: 14);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
    });
  }

  void backOffline() {
    geoRef.delete(currentUser.id);
    geoRef = null;

    isOnline = false;
    notifyListeners();
  }
}
