import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

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
