import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String email;
  String password;

  final _auth = FirebaseAuth.instance;

  Future loginUser(
      {@required Function(String) onSuccess, @required Function onFail}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      onFail("No Internet");
      return;
    }
    try {
      UserCredential credential = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        onFail(e);
      });

      if (credential.user != null) {
        notifyListeners();
        onSuccess(credential.user.uid);
      }
    } catch (error) {
      onFail(error);
    }
  }
}
