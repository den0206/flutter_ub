import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/model/FBUser.dart';

class SignUpModel extends ChangeNotifier {
  String email;
  String password;
  String fullname;
  int phomenumber;

  String typeString = UserType.Passanger.title;

  UserType get type {
    return convertType(typeString);
  }

  final _auth = FirebaseAuth.instance;

  Future registerUser(
      {@required Function(FBUser) onSuccess, @required Function onFail}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      onFail("No Internet");
      return;
    }

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(credential.user.uid);

      if (credential.user != null) {
        FBUser user = FBUser(
          credential.user.uid,
          fullname,
          email,
          phomenumber,
          convertType(
            typeString,
          ),
        );

        firebaseRef(FirebaseRef.user)
            .doc(credential.user.uid)
            .set(user.toMap());

        notifyListeners();
        onSuccess(user);
      }
    } catch (error) {
      onFail(error);
    }
  }

  chageValue(String value) {
    typeString = value;
    notifyListeners();
  }
}
