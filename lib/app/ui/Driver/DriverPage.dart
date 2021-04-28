import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Driver"),
          Text(currentUser.mycar.model),
          CustomButton(
              width: 100,
              title: "Logout",
              onPressed: () {
                final state = Provider.of<UserState>(context, listen: false);
                state.logout();
              })
        ],
      ),
    );
  }
}
