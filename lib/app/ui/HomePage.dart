import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/provider/MainModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({
    Key key,
  }) : super(key: key);

  final double sheetHeight = (Platform.isIOS) ? 300 : 275;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainPageModel>(
      create: (context) => MainPageModel(sheetHeight: sheetHeight),
      child: Scaffold(
        key: scaffoldKey,
        drawer: Container(
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
                DrawerItem(
                  icon: Icons.card_giftcard,
                  title: "Free Riders",
                ),
                DrawerItem(
                  icon: Icons.credit_card,
                  title: "CreditCards",
                ),
                DrawerItem(
                  icon: Icons.history,
                  title: "Ride History",
                ),
                DrawerItem(
                  icon: Icons.support,
                  title: "Support",
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Consumer<MainPageModel>(
              builder: (context, model, child) {
                return GoogleMap(
                  padding: EdgeInsets.only(bottom: model.mapBottomPadding),
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: _kLake,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                    mapController = controller;
                    model.changePadding();
                  },
                );
              },
            ),

            Positioned(
              top: 44,
              left: 20,
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentState.openDrawer();
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
                      Icons.menu,
                      color: Colors.black87,
                    ),
                    radius: 20,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            /// sheet
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: sheetHeight,
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
                        style:
                            TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                      ),
                      SearchPanel(
                        icon: Icons.search,
                        title: "Search Destination",
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
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
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
          if (auth.currentUser != null) Text(auth.currentUser.id),
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
