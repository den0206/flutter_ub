import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/provider/Driver/NewToripModel.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewTripsPage extends StatelessWidget {
  NewTripsPage({Key key}) : super(key: key);
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewTripModel>(
      create: (context) => NewTripModel(),
      child: Consumer<NewTripModel>(
        builder: (context, model, child) {
          return Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(bottom: model.mapBottomPadding),
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                compassEnabled: true,
                trafficEnabled: true,
                initialCameraPosition: firsrCameraPostion,
                markers: model.markers,
                circles: model.circles,
                polylines: model.polylines,
                onMapCreated: (controller) async {
                  _controller.complete(controller);
                  model.mapController = controller;

                  await model.getDirection();
                },
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: kBoxDecoration,
                  height: kacceptSheetHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "14 min",
                          style: TextStyle(
                            color: BrandColors.colorAccentPurple,
                            fontSize: 14,
                            fontFamily: "Brand-bold",
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Brand-bold",
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.call),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 23,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "images/pickicon.png",
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Position",
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "images/desticon.png",
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Destination",
                                  style: TextStyle(fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CustomButton(
                            width: 100,
                            title: "Arrives",
                            backColor: Colors.green,
                            onPressed: () {})
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
