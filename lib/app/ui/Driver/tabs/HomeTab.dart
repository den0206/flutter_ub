import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/provider/Driver/HomeTabModel.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/widgets/ConfitmSheet.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
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
                  padding: EdgeInsets.only(top: 135),
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
                  }),
              Container(
                height: 135,
                width: double.infinity,
                color: BrandColors.colorPrimary,
              ),
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: 150,
                      title: model.isOnline ? "Offline" : "Go Online",
                      backColor: model.isOnline ? Colors.blue : Colors.red,
                      onPressed: () {
                        // model.goOnline();
                        // model.getLovationUpdate();
                        //
                        showModalBottomSheet(
                          isDismissible: false,
                          context: context,
                          builder: (context) => ConfirmSheet(
                            isOnline: model.isOnline,
                            cancelAction: () {
                              Navigator.pop(context);
                            },
                            confirmAction: () {
                              if (!model.isOnline) {
                                model.goOnline();
                                model.getLovationUpdate();
                              } else {
                                model.backOffline();
                              }

                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
