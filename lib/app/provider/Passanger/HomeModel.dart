import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/helpers/helperMethod.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:flutter_ub/app/model/DirectionDetails.dart';
import 'package:flutter_ub/app/model/NearByDriver.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeModel extends ChangeNotifier {
  double sheetHeight = ksheetHeight;
  double rideSectionSheetHeight = 0;
  double requestingSheetHeight = 0;

  GoogleMapController mapController;
  DirectionDetails directionDetails;
  double mapBottomPadding = 0;

  DocumentReference _requestRef;

  var geoLocator = Geolocator();
  Position currentPosition;

  bool drawerOpen = true;

  Stream<List<DocumentSnapshot>> stream;
  BitmapDescriptor nearByIcon;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  void setPositionLocator(
      {BuildContext context, Function(Address) onSuccess}) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);

    currentPosition = position;
    createIcon(context);

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    Address address = await HelperMethod.findCordingAddress(position);

    if (address != null) {
      onSuccess(address);
    } else {
      print("No CurrentPoint");
    }
  }

  void createIcon(BuildContext context) {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));

      BitmapDescriptor.fromAssetImage(
              imageConfiguration,
              (Platform.isIOS)
                  ? "images/car_ios.png"
                  : "images/car_android.png")
          .then((icon) {
        nearByIcon = icon;
        startGeoFireListner();
      });
    }
  }

  void startGeoFireListner() {
    final geo = Geoflutterfire();

    GeoFirePoint center = geo.point(
        latitude: currentPosition.latitude,
        longitude: currentPosition.longitude);

    double radius = 50;
    String field = "postion";

    stream = geo
        .collection(collectionRef: firebaseRef(FirebaseRef.location))
        .within(center: center, radius: radius, field: field);

    stream.listen(
      (List<DocumentSnapshot> documnets) {
        documnets.forEach(
          (doc) {
            NearByDriver driver = NearByDriver.fromDocument(doc);

            LatLng driverPostion = LatLng(driver.latitude, driver.longitude);
            Marker thisMarker = Marker(
              markerId: MarkerId(
                "driver${driver.geoHash}",
              ),
              position: driverPostion,
              icon: nearByIcon,
              rotation: HelperMethod.generateRandomumber(360),
            );

            markers.add(thisMarker);
          },
        );
        notifyListeners();
      },
    );
  }

  void changePadding() {
    mapBottomPadding = sheetHeight - 30;
    // notifyListeners();
  }

  void showDetailSheet() async {
    await getDirection();

    drawerOpen = false;
    sheetHeight = 0;
    rideSectionSheetHeight = krideDetailSheetHeight;
    mapBottomPadding = rideSectionSheetHeight - 30;

    notifyListeners();
  }

  void resetApp() {
    drawerOpen = true;
    sheetHeight = ksheetHeight;
    rideSectionSheetHeight = 0;
    requestingSheetHeight = 0;
    mapBottomPadding = sheetHeight - 30;

    dismissGmapPer();

    setPositionLocator();
    startGeoFireListner();
  }

  dismissGmapPer() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    circles.clear();
  }

  showRequestSheet() {
    drawerOpen = true;
    rideSectionSheetHeight = 0;
    requestingSheetHeight = krequestSheetHeight;
    mapBottomPadding = requestingSheetHeight - 30;

    createRideRequest();
    notifyListeners();
  }

  Future<void> getDirection() async {
    var pickup = pickupAddress;
    var destination = destinationAddress;

    var pickupLating = LatLng(pickup.latitude, pickup.longtude);
    var destinationLating = LatLng(destination.latitude, destination.longtude);

    /// get Direction Details
    var details =
        await HelperMethod.getDirectionDetails(pickupLating, destinationLating);
    directionDetails = details;

    PolylinePoints polylinePoints = PolylinePoints();

    // polylineCoordinates.clear();

    dismissGmapPer();

    List<PointLatLng> results =
        polylinePoints.decodePolyline(details.encodedPoints);

    if (results.isNotEmpty) {
      print("add Coordinate");
      results.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }

    // polylines.clear();

    Polyline polyline = Polyline(
      polylineId: PolylineId("polyid"),
      color: Color.fromARGB(255, 95, 109, 237),
      points: polylineCoordinates,
      jointType: JointType.round,
      width: 4,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    polylines.add(polyline);

    LatLngBounds bounds;

    if (pickupLating.latitude > destinationLating.latitude &&
        pickupLating.longitude > destinationLating.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLating, northeast: pickupLating);
    } else if (pickupLating.longitude > destinationLating.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickupLating.latitude, destinationLating.longitude),
        northeast: LatLng(destinationLating.latitude, pickupLating.longitude),
      );
    } else if (pickupLating.latitude > destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLating.latitude, pickupLating.longitude),
        northeast: LatLng(pickupLating.latitude, destinationLating.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLating, northeast: destinationLating);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId("pickup"),
      position: pickupLating,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: "My Loacation"),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destination"),
      position: destinationLating,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: "Destination"),
    );

    markers.add(pickupMarker);
    markers.add(destinationMarker);

    Circle pickupCircle = Circle(
      circleId: CircleId("pickup"),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLating,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destination"),
      strokeColor: Colors.red,
      strokeWidth: 3,
      radius: 12,
      center: destinationLating,
      fillColor: BrandColors.colorAccent,
    );

    circles.add(pickupCircle);
    circles.add(destinationCircle);

    notifyListeners();
  }

  void createRideRequest() {
    Map pickupMap = {
      "latitude": pickupAddress.latitude.toString(),
      "longtude": pickupAddress.longtude.toString(),
    };

    Map destinationMap = {
      "latitude": destinationAddress.latitude.toString(),
      "longtude": destinationAddress.longtude.toString(),
    };
    final Map<String, dynamic> value = {
      "createdAt": DateTime.now(),
      "rider_name": currentUser.fullname,
      "pickup_address": pickupAddress.placeName,
      "destination_address": destinationAddress.placeName,
      "location": pickupMap,
      "destination": destinationMap,
      "payment_method": "cash",
      "driver_id": "waiting",
    };

    _requestRef = firebaseRef(FirebaseRef.ride).doc();
    _requestRef.set(value).whenComplete(() {
      print("add request");
    });
  }

  void cancelRequest() {
    _requestRef.delete();
  }
}
