import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/helpers/helperMethod.dart';
import 'package:flutter_ub/app/provider/HomeModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/ui/SearchPage.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (context) => HomeModel(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: _MainDrawer(),
        body: Consumer<HomeModel>(
          builder: (context, model, child) {
            return Stack(
              children: [
                /// google map
                _MainGmap(model: model),

                _DrawerButton(
                  model: model,
                  scaffoldKey: scaffoldKey,
                ),

                /// sheet
                _MainSheet(
                  model: model,
                ),
                _RideDetailSheet(
                  model: model,
                ),

                _RequestSheet(
                  model: model,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RequestSheet extends StatelessWidget {
  _RequestSheet({
    Key key,
    @required this.model,
  }) : super(key: key);

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: kBoxDecoration,
        height: model.requestingSheetHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: TextLiquidFill(
                    text: 'Request Ride...',
                    waveColor: BrandColors.colorTextSemiLight,
                    boxBackgroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 22,
                      fontFamily: "Brand-Bold",
                    ),
                    boxHeight: 40),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  model.cancelRequest();
                  model.resetApp();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1,
                      color: BrandColors.colorLightGrayFair,
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  "Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RideDetailSheet extends StatelessWidget {
  _RideDetailSheet({
    Key key,
    @required this.model,
  }) : super(key: key);

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: kBoxDecoration,
        height: model.rideSectionSheetHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: BrandColors.colorAccent1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/taxi.png",
                        height: 70,
                        width: 70,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: [
                          Text(
                            "Taxi",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Brand-bold",
                            ),
                          ),
                          Text(
                            (model.directionDetails != null)
                                ? model.directionDetails.distanceText
                                : "Can'T Get",
                            style: TextStyle(
                              fontSize: 16,
                              color: BrandColors.colorDimText,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        (model.directionDetails != null)
                            ? "\$ ${HelperMethod.estimateFares(model.directionDetails)}"
                            : "Can'T Get",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Brand-bold",
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 22,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    FontAwesomeIcons.moneyBillAlt,
                    size: 18,
                    color: BrandColors.colorTextLight,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text("Cash"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: BrandColors.colorTextLight,
                  ),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              CustomButton(
                  width: double.infinity,
                  title: "Request CAB",
                  onPressed: () {
                    model.showRequestSheet();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class _MainGmap extends StatelessWidget {
  _MainGmap({
    Key key,
    @required this.model,
  }) : super(
          key: key,
        );

  final Completer<GoogleMapController> _controller = Completer();
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      padding: EdgeInsets.only(bottom: model.mapBottomPadding),
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: firsrCameraPostion,
      polylines: model.polylines,
      markers: model.markers,
      circles: model.circles,
      onMapCreated: (controller) {
        _controller.complete(controller);
        model.mapController = controller;

        model.changePadding();
        model.setPositionLocator(
          onSuccess: (address) {
            Provider.of<UserState>(context, listen: false)
                .updatePickupAddress(address);
          },
        );
      },
    );
  }
}

class _MainSheet extends StatelessWidget {
  _MainSheet({
    Key key,
    @required this.model,
  }) : super(key: key);

  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: model.sheetHeight,
        decoration: BoxDecoration(
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
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                '"Nice to"',
                style: TextStyle(fontSize: 10),
              ),
              Text(
                '"Where are you going"',
                style: TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
              ),
              GestureDetector(
                onTap: () async {
                  var response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );

                  if (response == "getDirection") {
                    // model.getDirection(
                    //     Provider.of<UserState>(context, listen: false));

                    model.showDetailSheet(
                      Provider.of<UserState>(context, listen: false),
                    );
                  }
                },
                child: SearchPanel(
                  icon: Icons.search,
                  title: "Search Destination",
                ),
              ),
              SizedBox(
                height: 22,
              ),
              BoxPanel(
                icon: Icons.home,
                title: "Home",
                descripition: "Your Home Address",
              ),
              SizedBox(
                height: 10,
              ),
              BrandDivier(),
              SizedBox(
                height: 16,
              ),
              BoxPanel(
                icon: Icons.work,
                title: "Work",
                descripition: "Your Work Address",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton({
    Key key,
    @required this.model,
    @required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final HomeModel model;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 44,
      left: 20,
      child: GestureDetector(
        onTap: () {
          if (model.drawerOpen) {
            scaffoldKey.currentState.openDrawer();
          } else {
            model.resetApp();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: CircleAvatar(
            child: Icon(
              model.drawerOpen ? Icons.menu : Icons.arrow_back,
              color: Colors.black87,
            ),
            radius: 20,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MainDrawer extends StatelessWidget {
  const _MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Container(
              height: 160,
              child: Container(
                color: Colors.white,
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "images/user_icon.png",
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "userName",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BrandDivier(),
            SizedBox(
              height: 10,
            ),
            _DrawerItem(
              icon: Icons.card_giftcard,
              title: "Free Riders",
            ),
            _DrawerItem(
              icon: Icons.credit_card,
              title: "CreditCards",
            ),
            _DrawerItem(
              icon: Icons.history,
              title: "Ride History",
            ),
            _DrawerItem(
              icon: Icons.support,
              title: "Support",
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: kDrawerItemStyle,
      ),
    );
  }
}

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    Key key,
    @required this.icon,
    @required this.title,
  }) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class BoxPanel extends StatelessWidget {
  const BoxPanel({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.descripition,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String descripition;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              icon,
              color: BrandColors.colorDimText,
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  descripition,
                  style: TextStyle(
                    color: BrandColors.colorDimText,
                    fontSize: 11,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FirstView extends StatelessWidget {
  const FirstView({
    Key key,
    @required this.auth,
  }) : super(key: key);

  final UserState auth;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserState>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("alreadya")),
          if (currentUser != null) Text(currentUser.id),
          CustomButton(
            width: 100,
            title: "logout",
            backColor: Colors.red,
            onPressed: () {
              auth.logout();
            },
          ),
        ],
      ),
    );
  }
}
