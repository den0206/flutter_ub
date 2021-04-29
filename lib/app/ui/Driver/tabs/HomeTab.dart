import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/Driver/HomeTabModel.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  HomeTab({Key key}) : super(key: key);

  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabModel>(
      create: (context) => HomeTabModel(),
      child: Consumer<HomeTabModel>(
        builder: (context, model, child) {
          return Stack(
            children: [
              GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  initialCameraPosition: firsrCameraPostion,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    model.mapController = controller;

                    model.setPositionLocatoe();
                  })
            ],
          );
        },
      ),
    );
  }
}
