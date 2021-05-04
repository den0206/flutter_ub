import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final kDrawerItemStyle = TextStyle(fontSize: 16);

final kBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15),
    topRight: Radius.circular(15),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 15,
      spreadRadius: 0.5,
      offset: Offset(0.7, 0.7),
    ),
  ],
);

final CameraPosition firsrCameraPostion = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414);

const String kPassanger = "Passenger";
const String kDriver = "Driver";

/// sheet Heights
final double ksheetHeight = (Platform.isIOS) ? 300 : 275;
final double krideDetailSheetHeight = (Platform.isIOS) ? 235 : 260;
final double krequestSheetHeight = (Platform.isIOS) ? 220 : 195;

final double kacceptSheetHeight = (Platform.isIOS) ? 200 : 235;
