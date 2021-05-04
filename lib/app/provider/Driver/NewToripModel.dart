import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/helpers/helperMethod.dart';
import 'package:flutter_ub/app/model/DirectionDetails.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewTripModel extends ChangeNotifier {
  double sheetHeight = kacceptSheetHeight;
  GoogleMapController mapController;
  DirectionDetails directionDetails;
  double mapBottomPadding = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  PolylinePoints _polylinePoints = PolylinePoints();

  Future<void> getDirection() async {
    /// changeMapPadding

    mapBottomPadding = ksheetHeight - 30;

    /// current
    var currentLatLng = LatLng(pickupAddress.latitude, pickupAddress.longtude);

    /// user Example
    var pickUpLatLng =
        LatLng(destinationAddress.latitude, destinationAddress.longtude);

    var details =
        await HelperMethod.getDirectionDetails(currentLatLng, pickUpLatLng);

    // polylineCoordinates.clear();

    List<PointLatLng> results =
        _polylinePoints.decodePolyline(details.encodedPoints);

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

    if (currentLatLng.latitude > pickUpLatLng.latitude &&
        currentLatLng.longitude > pickUpLatLng.longitude) {
      bounds = LatLngBounds(southwest: pickUpLatLng, northeast: currentLatLng);
    } else if (currentLatLng.longitude > pickUpLatLng.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(currentLatLng.latitude, pickUpLatLng.longitude),
        northeast: LatLng(pickUpLatLng.latitude, currentLatLng.longitude),
      );
    } else if (currentLatLng.latitude > pickUpLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(pickUpLatLng.latitude, currentLatLng.longitude),
        northeast: LatLng(currentLatLng.latitude, pickUpLatLng.longitude),
      );
    } else {
      bounds = LatLngBounds(southwest: currentLatLng, northeast: pickUpLatLng);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    Marker pickupMarker = Marker(
      markerId: MarkerId("pickup"),
      position: currentLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId("destination"),
      position: pickUpLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markers.add(pickupMarker);
    markers.add(destinationMarker);

    Circle pickupCircle = Circle(
      circleId: CircleId("pickup"),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: currentLatLng,
      fillColor: BrandColors.colorGreen,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destination"),
      strokeColor: Colors.red,
      strokeWidth: 3,
      radius: 12,
      center: pickUpLatLng,
      fillColor: BrandColors.colorAccent,
    );

    circles.add(pickupCircle);
    circles.add(destinationCircle);

    notifyListeners();
  }
}
