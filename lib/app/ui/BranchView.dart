import 'package:flutter/material.dart';
import 'package:flutter_ub/app/model/FBUser.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/ui/Driver/MainTab.dart';
import 'package:flutter_ub/app/ui/Passanger/HomePage.dart';
import 'package:provider/provider.dart';

class BranchView extends StatelessWidget {
  const BranchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, model, child) {
        if (currentUser != null)
          switch (currentUser.type) {
            case UserType.Passanger:
              return HomePage();
            case UserType.Driver:
              return MainTabPage();
          }
        else {
          model.setUser();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
