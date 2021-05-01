import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Profile"),
          CustomButton(
            width: 100,
            title: "Logout",
            onPressed: () {
              final userState = Provider.of<UserState>(context, listen: false);
              userState.logout();
            },
          )
        ],
      ),
    );
  }
}
