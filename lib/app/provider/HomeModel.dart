import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/helpers/helperMethod.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:flutter_ub/app/model/DirectionDetails.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeModel extends ChangeNotifier {
  HomeModel({
    @required this.sheetHeight,
  });

  double sheetHeight;
  double rideSectionSheetHeight = 0;
  double requestingSheetHeight = 0;

  GoogleMapController mapController;
  DirectionDetails directionDetails;
  double mapBottomPadding = 0;

  var geoLocator = Geolocator();
  Position currentPosition;

  bool drawerOpen = true;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

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
    } else {
      print("No CurrentPoint");
    }
  }

  changePadding() {
    mapBottomPadding = sheetHeight - 30;
    notifyListeners();
  }

  void showDetailSheet(
    UserState userState,
    double rideHeight,
    double mapPadding,
  ) async {
    await getDirection(userState);

    drawerOpen = false;
    sheetHeight = 0;
    rideSectionSheetHeight = rideHeight;
    mapBottomPadding = rideSectionSheetHeight - 30;

    notifyListeners();
  }

  void dismissDetailSheet(double setHeight) {
    drawerOpen = true;
    sheetHeight = setHeight;
    rideSectionSheetHeight = 0;
    mapBottomPadding = sheetHeight - 30;

    dismissGmapPer();

    setPositionLocator();

    notifyListeners();
  }

  dismissGmapPer() {
    polylines.clear();
    polylineCoordinates.clear();
    markers.clear();
    circles.clear();
  }

  showRequestSheet(double setHeight) {
    drawerOpen = true;
    rideSectionSheetHeight = 0;
    requestingSheetHeight = setHeight;
    mapBottomPadding = requestingSheetHeight - 30;

    notifyListeners();
  }

  Future<void> getDirection(UserState userState) async {
    var pickup = userState.pickupAddress;
    var destination = userState.destinationAddress;

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
    final Map<String, dynamic> value = {};

    firebaseRef(FirebaseRef.ride).add(value);
  }
}
